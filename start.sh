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

echo ""
echo "===================================================="
echo "INICIANDO TMATE"
echo "O SSH VAI APARECER ABAIXO"
echo "Use o link sem ro- para controle total"
echo "===================================================="
echo ""

script -q -c "tmate -F" /dev/null || true

echo "tmate saiu. Mantendo container vivo..."
tail -f /tmp/http.log
