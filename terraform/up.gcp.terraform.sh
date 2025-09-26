# --- 1. PREPARAÇÃO E DEFINIÇÃO DE VARIÁVEIS ---

# Defina as variáveis (use o nome corrigido que o Terraform aceita)
export PROJECT_ID="meu-app-flask-466710"
export REGION="us-central1"
export REPOSITORY_NAME="my-flask-app"
export SERVICE_NAME="my-flask-app"

# --- 2. INSTALAÇÃO E AUTENTICAÇÃO ---

# Instala o gcloud e Terraform (Correto, mantenha esta etapa se estiver em um ambiente limpo)
# apt-get update ...
# apt-get install -y google-cloud-cli
# apt-get install -y terraform

# Autentica (Correto)
gcloud auth login --no-launch-browser
gcloud auth application-default login
gcloud config set project "${PROJECT_ID}"
gcloud config get-value project

# --- 3. PROVISIONAMENTO DA INFRAESTRUTURA (PARCIAL) ---

# Navega para o diretório do Terraform
cd /home/userlnx/docker/script_docker/cicd/terraform

# Inicializa (Correto)
terraform init

# Aplica para criar os recursos (Artifact Registry e APIs já devem ter sido criados, o serviço Cloud Run vai falhar)
# IMPORTANTE: A primeira aplicação vai criar o Artifact Registry.
terraform apply -auto-approve -var="project_id=${PROJECT_ID}" -var="region=${REGION}" -var="service_name=${SERVICE_NAME}"

# ----------------------------------------------------------------------
# --- 3.5. CORREÇÃO DE PERMISSÃO IAM (CRUCIAL) ---
# Adiciona a permissão para que o Cloud Run possa puxar imagens do Artifact Registry
# ----------------------------------------------------------------------

# O agente de serviço do Cloud Run geralmente é o SA Compute/App Engine padrão.
# Obtém o e-mail do Service Account que o Cloud Run usa por padrão.
export CLOUD_RUN_SA="${PROJECT_ID}@appspot.gserviceaccount.com"

echo "🔧 Concedendo permissão de leitura do Artifact Registry para ${CLOUD_RUN_SA}..."

gcloud artifacts repositories add-iam-policy-binding "${REPOSITORY_NAME}" \
    --location="${REGION}" \
    --member="serviceAccount:${CLOUD_RUN_SA}" \
    --role="roles/artifactregistry.reader" \
    --project="${PROJECT_ID}"

# --- 4. BUILD E DEPLOY VIA CLOUD SHELL/CLOUD BUILD ---

# Navega para o diretório raiz do código (onde está o Dockerfile)
cd ..

echo "🚀 Iniciando Build & Deploy na Nuvem via gcloud run deploy --source"

# O gcloud faz o build e o push. Agora, o Cloud Run terá permissão para puxar.
gcloud run deploy "${SERVICE_NAME}" \
    --source "." \
    --region "${REGION}" \
    --platform managed \
    --allow-unauthenticated \
    --port 5000 \
    --project "${PROJECT_ID}" \
    --quiet 

# --- 5. SINCRONIZAÇÃO DA INFRAESTRUTURA ---

# Retorna ao diretório do Terraform
cd terraform

# Aplica NOVAMENTE. O serviço Cloud Run já está funcionando.
# O Terraform apenas atualiza seu arquivo de estado para refletir o sucesso da implantação.
terraform apply -auto-approve -var="project_id=${PROJECT_ID}" -var="region=${REGION}" -var="service_name=${SERVICE_NAME}"

# 2. Execute o comando de destruição, passando as variáveis
#terraform destroy -var="project_id=meu-app-flask-466710" -var="region=us-central1" -var="service_name=my-flask-app"