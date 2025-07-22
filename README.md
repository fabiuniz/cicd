<!-- 
  Tags: DevOps
  Label: ⚙️ Dockerizada com CI/CD Automatizado.
  Description: Aplicação Flask Dockerizada com CI/CD Automatizado
  path_hook: hookfigma.hook18
-->

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

## 📋 Como Obter Variáveis do Google Cloud Platform

### 🔍 **Localizando Informações Essenciais do GCP**

#### **1️⃣ PROJECT_ID - ID do Projeto**

**Método 1: Console Web**
1. Acesse [Google Cloud Console](https://console.cloud.google.com)
2. No topo da página, clique no **seletor de projeto**
3. Na janela que abrir, você verá:
   - **Nome do Projeto**: Ex: "Meu App Flask"
   - **ID do Projeto**: Ex: `meu-projeto-flask-123456` ✅ **Esta é a variável!**

**Método 2: Cloud Shell/Terminal**
```bash
# Listar todos os projetos
gcloud projects list

# Ver projeto atual
gcloud config get-value project

# Definir projeto (se necessário)
gcloud config set project SEU_PROJECT_ID
```

**Método 3: URL do Console**
- Na URL do console: `https://console.cloud.google.com/home/dashboard?project=meu-projeto-123`
- O que vem após `project=` é seu PROJECT_ID ✅

#### **2️⃣ REGION - Região do Google Cloud**

**Regiões Mais Usadas no Brasil:**
```bash
# São Paulo (recomendada para BR)
southamerica-east1

# Outras opções próximas
us-east1        # Virgínia do Norte (boa latência)
us-central1     # Iowa (padrão em muitos tutoriais)
```

**Ver todas as regiões disponíveis:**
```bash
# Listar regiões do Cloud Run
gcloud run regions list

# Listar todas as regiões do GCP
gcloud compute regions list
```

#### **3️⃣ SERVICE_ACCOUNT_EMAIL - Email da Conta de Serviço**

**Após criar a Service Account:**
```bash
# Listar todas as service accounts
gcloud iam service-accounts list

# Formato padrão será:
# github-actions-sa@SEU_PROJECT_ID.iam.gserviceaccount.com
```

**No Console Web:**
1. **IAM & Admin** → **Service Accounts**
2. Encontre a conta criada (ex: "github-actions-sa")
3. O email estará na coluna **Email** ✅

#### **4️⃣ ARTIFACT_REGISTRY_URL - URL do Repositório**

**Formato padrão:**
```
REGION-docker.pkg.dev/PROJECT_ID/REPOSITORY_NAME
```

**Exemplo real:**
```
us-central1-docker.pkg.dev/meu-projeto-123/my-flask-app
```

**Verificar no terminal:**
```bash
# Listar repositórios
gcloud artifacts repositories list

# Ver detalhes de um repositório específico
gcloud artifacts repositories describe REPOSITORY_NAME \
  --location=REGION
```

### 📊 **Script para definição e Coleta de Variáveis**

Cole este script no **Google Cloud Shell** para obter todas as informações:

```bash
#!/bin/bash

echo "🔍 COLETANDO INFORMAÇÕES DO GCP..."
echo "=================================="

# Obter PROJECT_ID atual
PROJECT_ID=$(gcloud config get-value project)
echo "📌 PROJECT_ID: $PROJECT_ID"

# Obter região padrão (se configurada)
REGION=$(gcloud config get-value compute/region 2>/dev/null)
if [ -z "$REGION" ]; then
    REGION="us-central1"  # Padrão
fi
echo "🌍 REGION: $REGION"

# Definir nomes padrão
SERVICE_ACCOUNT_NAME="github-actions-sa"
REPOSITORY_NAME="my-flask-app"
SERVICE_NAME="my-flask-app"

echo "👤 SERVICE_ACCOUNT_EMAIL: $SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"
echo "📦 ARTIFACT_REGISTRY_URL: $REGION-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_NAME"
echo "🐳 REPOSITORY_NAME: $REPOSITORY_NAME"
echo "🚀 SERVICE_NAME: $SERVICE_NAME"

echo ""
echo "=================================="
echo "✅ INFORMAÇÕES COLETADAS COM SUCESSO!"
echo ""
echo "📝 PRÓXIMOS PASSOS:"
echo "1. Use PROJECT_ID como GitHub Secret: GCP_PROJECT_ID"
echo "2. Use as outras variáveis no arquivo .github/workflows/deploy.yml"
echo "=================================="
```
### 📊 **Forma manual para definição**
```bash

🌱 Definir variáveis (SUBSTITUA SEU_PROJECT_ID)
export PROJECT_ID="SEU_PROJECT_ID_AQUI"
export SERVICE_ACCOUNT_NAME="github-actions-sa"
export REGION="us-central1"
export REPOSITORY_NAME="my-flask-app"
echo "Projeto atual: $(gcloud config get-value project)"

```
---

## ⚡ Configuração Rápida

### 1️⃣ **Configurar GCP (Cloud Shell)**

```bash

🔧 Listar projetos disponíveis e identificar projeto ativo
gcloud projects list
gcloud config get-value project

✅ Configurar projeto
gcloud config set project $PROJECT_ID

🔧 Verificar APIs habilitadas
gcloud services list \
  --enabled \
  --filter="name:(run.googleapis.com OR artifactregistry.googleapis.com)" \
  --format="value(name)"

✅ Habilitar APIs necessárias
gcloud services enable run.googleapis.com \
  artifactregistry.googleapis.com \
  iam.googleapis.com \
  cloudbuild.googleapis.com

🔧 Verificar Repositório Artifact Registry existe
gcloud artifacts repositories list --format="table(name,location)"

✅ Criar repositório Artifact Registry
gcloud artifacts repositories create $REPOSITORY_NAME \
  --repository-format=docker \
  --location=$REGION \
  --description="Repositório Docker para $REPOSITORY_NAME"

🔧 Verificar todas Service Accounts que exitem
gcloud iam service-accounts list

🔧 Verificar Service Account existe
gcloud iam service-accounts list --filter="email:github-actions-sa@*"

✅ Criar Service Account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --display-name="Service Account para GitHub Actions"

🔧 Verificar Permissões da Service Account
gcloud projects get-iam-policy $(gcloud config get-value project) \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:github-actions-sa@*" \
  --format="table(bindings.role)"

✅ Conceder permissões
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

✅ Gerar chave da Service Account
gcloud iam service-accounts keys create sa-key.json \
  --iam-account="$SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"

✅ Exibir conteúdo para copiar
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

## 🔍 Deploy do Pipeline CI/CD -  Actions GitHub
```bash
git checkout gcp-deploy
git merge <sua-branch-de-trabalho>
git push origin gcp-deploy
```

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

### ⚠️ **Problemas com Variáveis do GCP**

**Erro: "Project not found"**
```bash

# Selecionar projeto correto
gcloud config set project SEU_PROJECT_ID_CORRETO
```

**Erro: "Service account not found"**
```bash

# Recriar se necessário
gcloud iam service-accounts create github-actions-sa \
  --display-name="GitHub Actions Service Account"
```

**Erro: "Repository not found"**
```bash
# Verificar repositórios existentes
gcloud artifacts repositories list

# Criar repositório se necessário
gcloud artifacts repositories create my-flask-app \
  --repository-format=docker \
  --location=us-central1
```

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

## 💡 **Dicas Importantes**

### **✅ Boas Práticas:**
- **Sempre use** PROJECT_ID, nunca o nome do projeto
- **Mantenha consistência** nos nomes de repositório e serviço
- **Escolha uma região** e use sempre a mesma
- **Documente** as variáveis escolhidas para sua equipe

### **🔒 Segurança:**
- **Nunca** exponha a chave JSON da service account
- **Use** GitHub Secrets para informações sensíveis
- **Limite** permissões da service account ao mínimo necessário

### **💰 Custos:**
- **Prefira** regiões próximas para reduzir latência
- **Monitore** o uso no Google Cloud Console
- **Use** tier gratuito sempre que possível

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
- 📖 **Documentação oficial**: [Google Cloud Docs](https://cloud.google.com/docs)
- 💬 **Community**: [Google Cloud Community](https://cloud.google.com/community)
- 🆘 **Stack Overflow**: Tag `google-cloud-platform`

---

**🎉 Projeto criado com Flask + Docker + GitHub Actions + Google Cloud Run**

*Desenvolvido com ❤️ para demonstrar CI/CD moderno e eficiente*

## 👨‍💻 Autor

[Fabiano Rocha/Fabiuniz]