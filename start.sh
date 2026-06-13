#!/usr/bin/env bash
set -e

export TERM=xterm-256color
export PORT="${PORT:-8080}"

echo "Iniciando servidor HTTP na porta $PORT..."
python3 -m http.server "$PORT" --bind 0.0.0.0 > /tmp/http.log 2>&1 &

echo "Criando config do tmate..."
cat > /tmp/tmate.conf <<'EOF'
set -g tmate-server-host ssh.tmate.io
set -g tmate-server-port 443
set -g tmate-server-rsa-fingerprint SHA256:Vp6XvJfRQjR8W2H4DB6I2oKQu3g7DbbW4MjO8kA+I9U
set -g tmate-server-ed25519-fingerprint SHA256:sdNsK9t0v3T8JcKk7Yw5E9ZK1gSgL2V0fW6+WvQx4fA
EOF

echo "Testando DNS e porta 443..."
getent hosts ssh.tmate.io || true
nc -vz ssh.tmate.io 443 || true

echo "Matando tmate antigo..."
pkill -f tmate || true
rm -f /tmp/tmate.sock

echo "Iniciando tmate com config forçado..."
tmate -f /tmp/tmate.conf -S /tmp/tmate.sock new-session -d

echo "Aguardando tmate gerar link..."
for i in $(seq 1 40); do
  SSH_LINK="$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' 2>/dev/null || true)"

  if echo "$SSH_LINK" | grep -q '^ssh '; then
    echo ""
    echo "===================================================="
    echo "TMATE SSH COMPLETO:"
    echo "$SSH_LINK"
    echo ""
    echo "TMATE SSH SOMENTE LEITURA:"
    tmate -S /tmp/tmate.sock display -p '#{tmate_ssh_ro}' || true
    echo ""
    echo "TMATE WEB:"
    tmate -S /tmp/tmate.sock display -p '#{tmate_web}' || true
    echo "===================================================="
    echo ""
    break
  fi

  echo "Aguardando tmate... $i"
  tmate -S /tmp/tmate.sock show-messages || true
  sleep 2
done

echo "Status final do tmate:"
tmate -S /tmp/tmate.sock show-messages || true

echo "Processos:"
ps aux | grep tmate || true

echo "Container pronto."
tail -f /tmp/http.log
