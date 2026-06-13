FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV PORT=8080

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    openssh-client \
    tmate \
    tmux \
    ncurses-term \
    python3 \
    procps \
    netcat-openbsd \
    dnsutils \
    util-linux \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app

WORKDIR /app

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
