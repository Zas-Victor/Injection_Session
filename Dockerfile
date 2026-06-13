FROM ollama/ollama:latest

ENV OLLAMA_ORIGINS=*
ENV OLLAMA_MODELS=/var/data/ollama
ENV OLLAMA_MODEL=qwen2.5-coder:3b

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 10000

ENTRYPOINT []
CMD ["/start.sh"]
