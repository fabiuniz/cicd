# 🚀 Aplicação Flask Dockerizada com CI/CD Automatizado

## 📖 Sobre o Projeto

Este projeto implementa uma aplicação web moderna em Flask com frontend estiloso, empacotada em Docker e com pipeline de CI/CD totalmente automatizado usando GitHub Actions para deploy no Google Cloud Run.

### ✨ Características:
- **Frontend Responsivo** com design glassmorphism e animações suaves
- **Deploy Automatizado** via GitHub Actions
- **Containerização** com Docker otimizado
- **Monitoramento** com health checks
- **Escalabilidade** automática no Cloud Run

---

## 🎯 Demonstração

A aplicação exibe:
- ✅ Mensagem "Hello World" estilizada
- 🕐 Hora atual em tempo real (São Paulo, Brasil)
- 📱 Interface responsiva para dispositivos móveis
- 🎨 Design moderno com efeitos visuais elegantes
- 🔍 Status do deploy e informações do sistema

---

## 📁 Estrutura do Projeto

```
my-flask-app-docker/
├── app.py                    # 🐍 Aplicação Flask principal
├── requirements.txt          # 📦 Dependências Python
├── Dockerfile               # 🐳 Configuração Docker
├── README.md               # 📖 Documentação
└── .github/
    └── workflows/
        └── deploy.yml      # ⚙️ Pipeline CI/CD
```

---

## 🔧 Pré-requisitos

### ☁️ Google Cloud Platform (GCP)
- Conta ativa com billing habilitado
- Projeto criado (anote o `PROJECT_ID`)

### 🐙 GitHub
- Repositório criado
- Acesso para configurar secrets

### 💻 Desenvolvimento Local (Opcional)
- Docker Desktop
- Python 3.9+
- Git

---

## ⚡ Configuração Rápida

### 1️⃣ **Configurar GCP (Cloud Shell)**

```bash
# ✅ Definir variáveis (SUBSTITUA SEU_PROJECT_ID)
export PROJECT_ID="SEU_PROJECT_ID_AQUI"
export SERVICE_ACCOUNT_NAME="github-actions-sa"
export REGION="us-central1"
export REPOSITORY_NAME="my-flask-app"

# ✅ Configurar projeto
gcloud config set project $PROJECT_ID

# ✅ Habilitar APIs necessárias
gcloud services enable run.googleapis.com \
  artifactregistry.googleapis.com \
  iam.googleapis.com \
  cloudbuild.googleapis.com

# ✅ Criar repositório Artifact Registry
gcloud artifacts repositories create $REPOSITORY_NAME \
  --repository-format=docker \
  --location=$REGION \
  --description="Repositório Docker para $REPOSITORY_NAME"

# ✅ Criar Service Account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name="Service Account para GitHub Actions"

# ✅ Conceder permissões
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# ✅ Gerar chave da Service Account
gcloud iam service-accounts keys create sa-key.json \
  --iam-account="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

# ✅ Exibir conteúdo para copiar
echo "=== COPIE TODO O CONTEÚDO ABAIXO ==="
cat sa-key.json
```

### 2️⃣ **Configurar GitHub Secrets**

No seu repositório GitHub:

1. **Settings** → **Secrets and variables** → **Actions**
2. **New repository secret** e crie:

#### 🔑 **Secret 1:**
```
Name: GCP_SA_KEY
Value: [Cole todo o JSON do arquivo sa-key.json aqui]
```

#### 🆔 **Secret 2:**
```
Name: GCP_PROJECT_ID  
Value: [Seu PROJECT_ID do GCP]
```

### 3️⃣ **Deploy Automático**

```bash
# Clone seu repositório
git clone <URL_DO_SEU_REPOSITORIO>
cd my-flask-app-docker

# Adicione os arquivos do projeto
git add .
git commit -m "🚀 Initial deploy to GCP Cloud Run"
git push origin main
```

🎉 **Pronto!** O GitHub Actions será executado automaticamente e fará o deploy.

---

## 🔍 Verificação do Deploy

### Via Google Cloud Console:
1. Acesse [Cloud Run](https://console.cloud.google.com/run)
2. Encontre o serviço `my-flask-app`
3. Clique na URL fornecida

### Via Command Line:
```bash
# Listar serviços
gcloud run services list --region=us-central1

# Ver logs
gcloud run services logs read my-flask-app --region=us-central1
```

---

## 🖥️ Desenvolvimento Local

### Executar com Python:
```bash
# Criar ambiente virtual
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Instalar dependências
pip install -r requirements.txt

# Executar aplicação
python app.py
```

### Executar com Docker:
```bash
# Build da imagem
docker build -t my-flask-app .

# Executar container
docker run -p 5000:5000 -e PORT=5000 my-flask-app
```

Acesse: `http://localhost:5000`

---

## 📋 Variáveis do Projeto

| Variável | Tipo | Onde Configurar | Exemplo |
|----------|------|-----------------|---------|
| `GCP_SA_KEY` | GitHub Secret | Repo Settings | `{json completo}` |
| `GCP_PROJECT_ID` | GitHub Secret | Repo Settings | `meu-projeto-123` |
| `REGION` | Workflow | `.github/workflows/deploy.yml` | `us-central1` |
| `SERVICE_NAME` | Workflow | `.github/workflows/deploy.yml` | `my-flask-app` |
| `REPOSITORY_NAME` | Workflow | `.github/workflows/deploy.yml` | `my-flask-app` |

---

## 🎨 Recursos do Frontend

### Design Moderno:
- **Glassmorphism**: Efeito de vidro translúcido
- **Gradientes**: Fundo com degradê elegante  
- **Animações**: Transições suaves e fade-in
- **Responsivo**: Adaptado para mobile e desktop
- **Tipografia**: Fontes modernas e legíveis

### Funcionalidades:
- ⏰ **Relógio em Tempo Real**: Hora de São Paulo
- 📅 **Data Formatada**: Em português brasileiro
- 🌍 **Timezone Info**: Fuso horário detalhado
- 💚 **Status Indicator**: Confirmação de deploy
- 📱 **Mobile First**: Design otimizado para celulares

---

## 🔧 Resolução de Problemas

### ❌ **Erro: "Permission Denied"**
```bash
# Verificar permissões da service account
gcloud projects get-iam-policy $PROJECT_ID \
  --format="table(bindings.role)" \
  --filter="bindings.members:serviceAccount:github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com"
```

### ❌ **Erro: "Repository Not Found"**
```bash
# Verificar se repositório existe
gcloud artifacts repositories list --location=us-central1
```

### ❌ **Erro: "API Not Enabled"**
```bash
# Verificar APIs habilitadas
gcloud services list --enabled --filter="name:(run.googleapis.com OR artifactregistry.googleapis.com)"
```

### ❌ **Build Failed**
- Verifique se todos os arquivos estão no repositório
- Confirme se os secrets estão configurados corretamente
- Veja os logs no GitHub Actions

---

## 💰 Custos e Limites Gratuitos

### Google Cloud Run (Tier Gratuito):
- ✅ **2 milhões** de requisições/mês
- ✅ **180.000** vCPU-segundos/mês  
- ✅ **360.000** GiB-segundos de memória/mês
- ✅ **1 GB** de largura de banda/mês

### Google Cloud (Novos Usuários):
- 🎁 **$300 em créditos** para 90 dias
- 🆓 **Always Free** tier para sempre

---

## 🧹 Limpeza de Recursos

Para evitar custos desnecessários:

```bash
# Deletar serviço Cloud Run
gcloud run services delete my-flask-app --region=us-central1

# Deletar repositório Artifact Registry  
gcloud artifacts repositories delete my-flask-app --location=us-central1

# Deletar service account
gcloud iam service-accounts delete github-actions-sa@$PROJECT_ID.iam.gserviceaccount.com
```

---

## 🏗️ Pipeline CI/CD

### O que acontece no deploy:
1. 🔍 **Checkout**: Baixa código do repositório
2. 🔐 **Auth**: Autentica no Google Cloud
3. 🐳 **Build**: Constrói imagem Docker
4. 📤 **Push**: Envia para Artifact Registry
5. 🚀 **Deploy**: Atualiza serviço no Cloud Run
6. ✅ **URL**: Exibe URL da aplicação

### Triggers:
- ✅ Push para branch `main`
- ✅ Pull Request para `main`

---

## 🤝 Contribuições

Contribuições são bem-vindas! Para contribuir:

1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Commit: `git commit -m "✨ Adiciona nova funcionalidade"`
4. Push: `git push origin feature/nova-funcionalidade`
5. Abra um Pull Request

---

## 📄 Licença

Este projeto está sob licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 🆘 Suporte

### Problemas Comuns:
- 📖 Consulte a seção "Resolução de Problemas"
- 🔍 Veja os logs no GitHub Actions
- 📊 Monitore no Google Cloud Console

### Precisa de Ajuda?
- 🐛 Abra uma [Issue](../../issues)
- 💬 Inicie uma [Discussion](../../discussions)
- 📧 Entre em contato através do GitHub

---

**🎉 Projeto criado com Flask + Docker + GitHub Actions + Google Cloud Run**

*Desenvolvido com ❤️ para demonstrar CI/CD moderno e eficiente*