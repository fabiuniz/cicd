#!/bin/bash

# --- Validação e Definição de Parâmetros ---
# Verifica se o ID do projeto foi fornecido como argumento.
if [ -z "$1" ]; then
  echo "❌ ERRO: O ID do projeto não foi fornecido."
  echo "➡️ Uso: ./up.gcp.sh <PROJECT_ID>"
  exit 1
fi

# Define o PROJECT_ID com o valor do primeiro argumento ($1)
export PROJECT_ID="$1"

# Define outras variáveis padrão.
export SERVICE_ACCOUNT_NAME="github-actions-sa"
export REGION="us-central1"
export REPOSITORY_NAME="my-flask-app"
export SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo "✅ Iniciando a configuração para o projeto: ${PROJECT_ID}"
echo "======================================================"

# --- Execução dos Comandos ---

# ✅ Configurar projeto
gcloud config set project "${PROJECT_ID}"

# ✅ Habilitar APIs necessárias
gcloud services enable     run.googleapis.com     artifactregistry.googleapis.com     iam.googleapis.com     cloudbuild.googleapis.com

# ✅ Criar repositório Artifact Registry
echo "🔧 Criando repositório Artifact Registry..."
gcloud artifacts repositories create "${REPOSITORY_NAME}"     --repository-format=docker     --location="${REGION}"     --description="Repositório Docker para ${REPOSITORY_NAME}" 2>/dev/null || echo " Repositório já existe."

# ✅ Criar Service Account
echo "🔧 Criando Service Account..."
gcloud iam service-accounts create "${SERVICE_ACCOUNT_NAME}"     --display-name="Service Account para GitHub Actions" 2>/dev/null || echo " Service Account já existe."

# ✅ Conceder permissões
echo "🔧 Concedendo permissões à Service Account..."
gcloud projects add-iam-policy-binding "${PROJECT_ID}"     --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}"     --role="roles/run.admin" --no-user-output-enabled > /dev/null
gcloud projects add-iam-policy-binding "${PROJECT_ID}"     --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}"     --role="roles/artifactregistry.writer" --no-user-output-enabled > /dev/null
gcloud projects add-iam-policy-binding "${PROJECT_ID}"     --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}"     --role="roles/iam.serviceAccountUser" --no-user-output-enabled > /dev/null

# ✅ Gerar chave da Service Account e exibir conteúdo
echo "🔧 Gerando chave da Service Account..."
gcloud iam service-accounts keys create sa-key.json     --iam-account="${SERVICE_ACCOUNT_EMAIL}"

echo ""
echo "=== COPIE O ID ${PROJECT_ID} PARA O GitHub Secret GCP_PROJECT_ID ==="
echo "=== COPIE TODO O CONTEÚDO ABAIXO PARA O GitHub Secret GCP_SA_KEY ==="
echo ""
cat sa-key.json
echo ""
echo "=========================================================="
echo "✅ Configuração concluída. Arquivo sa-key.json gerado."
# https://console.cloud.google.com/welcome?cloudshell=true
