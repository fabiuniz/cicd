#!/bin/bash

# --- Validação e Definição de Parâmetros ---
# Verifica se o ID do projeto foi fornecido como argumento.
if [ -z "$1" ]; then
  echo "❌ ERRO: O ID do projeto não foi fornecido."
  echo "➡️ Uso: ./down.gpc.sh <PROJECT_ID>"
  exit 1
fi

# Define o PROJECT_ID com o valor do primeiro argumento ($1)
export PROJECT_ID="$1"

# Define outras variáveis padrão.
export SERVICE_ACCOUNT_NAME="github-actions-sa"
export REGION="us-central1"
export REPOSITORY_NAME="my-flask-app"
export SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "✅ Iniciando a remoção de recursos do projeto: ${PROJECT_ID}"
echo "========================================================"

# --- Execução dos Comandos de Remoção ---

# 1. Deletar o serviço do Cloud Run
echo "🔧 Deletando o serviço do Cloud Run (${REPOSITORY_NAME})..."
gcloud run services delete "${REPOSITORY_NAME}" --region="${REGION}" --quiet 2>/dev/null || echo " Serviço do Cloud Run não encontrado ou já deletado."

# 2. Deletar o repositório do Artifact Registry
echo "🔧 Deletando o repositório do Artifact Registry (${REPOSITORY_NAME})..."
gcloud artifacts repositories delete "${REPOSITORY_NAME}" --location="${REGION}" --quiet 2>/dev/null || echo " Repositório do Artifact Registry não encontrado ou já deletado."

# 3. Deletar a Service Account
echo "🔧 Deletando a Service Account (${SERVICE_ACCOUNT_EMAIL})..."
gcloud iam service-accounts delete "${SERVICE_ACCOUNT_EMAIL}" --quiet 2>/dev/null || echo " Service Account não encontrada ou já deletada."

echo "✅ Limpeza concluída para o projeto ${PROJECT_ID}."
echo "========================================================"
echo "📝 Observação: Pode levar alguns minutos para as métricas da API pararem de mostrar tráfego."
