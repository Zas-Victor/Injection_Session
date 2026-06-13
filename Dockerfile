FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    wget \
    ca-certificates \
    openssh-client \
    tmate \
    tmux \
    ncurses-term \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app && echo "tmate session"

WORKDIR /app

EXPOSE 6080

CMD ["bash", "-lc", "tmate -F"]
