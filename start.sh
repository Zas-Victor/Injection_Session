#!/usr/bin/env bash
set -e

export PORT="${PORT:-10000}"
export OLLAMA_HOST="0.0.0.0:${PORT}"
export OLLAMA_ORIGINS="${OLLAMA_ORIGINS:-*}"
export OLLAMA_MODELS="${OLLAMA_MODELS:-/var/data/ollama}"
export OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5-coder:3b}"

mkdir -p "$OLLAMA_MODELS"

echo "Iniciando Ollama em $OLLAMA_HOST"
echo "Modelo: $OLLAMA_MODEL"

ollama serve &
OLLAMA_PID=$!

echo "Aguardando Ollama iniciar..."
sleep 8

echo "Baixando modelo..."
ollama pull "$OLLAMA_MODEL" || true

echo "Modelos instalados:"
ollama list || true

echo "Ollama pronto na porta $PORT"
wait "$OLLAMA_PID"
