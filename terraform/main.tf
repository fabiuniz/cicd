# Arquivo: terraform/main.tf

# ----------------------------------------
# 1. PROVEDORES
# ----------------------------------------
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.0"
    }
  }
}

# CONFIGURAÇÃO DE PROVEDORES CORRIGIDA!
# Isso garante que tanto 'google' quanto 'google-beta' saibam qual projeto usar.
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
# ----------------------------------------
# 2. VARIÁVEIS DE CONFIGURAÇÃO
# ----------------------------------------
variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região para os recursos do GCP (ex: us-central1)"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Nome do serviço Cloud Run e do repositório Artifact Registry"
  type        = string
  default     = "meu-app-flask" # Nome mais adequado ao projeto Flask
}

# ----------------------------------------
# 3. HABILITAR APIS OBRIGATÓRIAS
# ----------------------------------------
# Habilita a API do Artifact Registry
resource "google_project_service" "artifactregistry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Habilita a API do Cloud Run
resource "google_project_service" "run_api" {
  project = var.project_id
  service = "run.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.artifactregistry_api]
}

# ----------------------------------------
# 4. ARTIFACT REGISTRY
# ----------------------------------------
resource "google_artifact_registry_repository" "repository" {
  # provider = google-beta REMOVIDO/DESNECESSÁRIO, pois o provider 'google-beta' já foi configurado acima.
  location      = var.region
  repository_id = var.service_name
  description   = "Repositório Docker para a aplicação ${var.service_name}"
  format        = "DOCKER"
  depends_on    = [google_project_service.artifactregistry_api]
}

# ----------------------------------------
# 5. CLOUD RUN SERVICE (V2)
# ----------------------------------------
resource "google_cloud_run_v2_service" "service" {
  name       = var.service_name
  location   = var.region
  project    = var.project_id
  depends_on = [google_project_service.run_api]
  
  # Permite acesso não autenticado (padrão para apps web)
  ingress = "INGRESS_TRAFFIC_ALL" 

  template {
    # Configuração do Container Principal
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repository.repository_id}/${var.service_name}:latest"
      
      ports {
        # A porta que sua aplicação Flask/Python escuta
        container_port = 5000 
      }
      
      resources {
        cpu_idle = true
        
        # CORREÇÃO: 'limits' DEVE SER UM MAPA
        limits = {
          memory = "512Mi"
          cpu    = "1000m"
        }
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 5 # Ajustado para um limite mais razoável
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

# ----------------------------------------
# 6. SAÍDAS (OUTPUTS)
# ----------------------------------------
output "repository_url" {
  description = "URL completa do repositório Artifact Registry"
  value       = google_artifact_registry_repository.repository.id
}

output "service_url" {
  description = "A URL de acesso ao serviço Cloud Run"
  value       = google_cloud_run_v2_service.service.uri
}