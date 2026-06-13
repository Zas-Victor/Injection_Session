#!/usr/bin/env bash
set -e

export TERM=xterm-256color
export PORT="${PORT:-8080}"

echo "Iniciando servidor HTTP na porta $PORT..."
python3 -m http.server "$PORT" --bind 0.0.0.0 > /tmp/http.log 2>&1 &

echo "Configurando tmate na porta 443..."
mkdir -p /root

cat > /root/.tmate.conf <<'EOF'
set -g tmate-server-host ssh.tmate.io
set -g tmate-server-port 443
EOF

echo "Testando rede..."
getent hosts ssh.tmate.io || true
nc -vz ssh.tmate.io 443 || true

echo "Iniciando tmate..."
rm -f /tmp/tmate.sock

tmate -S /tmp/tmate.sock new-session -d

echo "Aguardando tmate ficar pronto..."
for i in $(seq 1 60); do
  if tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' 2>/dev/null | grep -q 'ssh '; then
    break
  fi

  echo "Aguardando tmate... $i"
  sleep 2
done

echo ""
echo "===================================================="
echo "TMATE SSH COMPLETO:"
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' || true
echo ""
echo "TMATE SSH SOMENTE LEITURA:"
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh_ro}' || true
echo ""
echo "TMATE WEB:"
tmate -S /tmp/tmate.sock display -p '#{tmate_web}' || true
echo "===================================================="
echo ""

echo "Mensagens do tmate:"
tmate -S /tmp/tmate.sock show-messages || true

echo "Container pronto."
tail -f /tmp/http.log
