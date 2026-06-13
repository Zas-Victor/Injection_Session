FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV PORT=6080

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    wget \
    ca-certificates \
    openssh-client \
    tmate \
    tmux \
    ncurses-term \
    python3 \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app

WORKDIR /app

EXPOSE 6080

CMD bash -lc '\
  export TERM=xterm-256color; \
  export PORT="${PORT:-6080}"; \
  echo "Iniciando servidor HTTP na porta $PORT..."; \
  python3 -m http.server "$PORT" --bind 0.0.0.0 > /tmp/http.log 2>&1 & \
  echo "Iniciando tmate..."; \
  rm -f /tmp/tmate.sock; \
  tmate -S /tmp/tmate.sock new-session -d; \
  tmate -S /tmp/tmate.sock wait tmate-ready; \
  echo ""; \
  echo "===================================================="; \
  echo "TMATE SSH COMPLETO:"; \
  tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}"; \
  echo ""; \
  echo "TMATE SSH SOMENTE LEITURA:"; \
  tmate -S /tmp/tmate.sock display -p "#{tmate_ssh_ro}"; \
  echo "===================================================="; \
  echo ""; \
  tail -f /tmp/http.log \
'
