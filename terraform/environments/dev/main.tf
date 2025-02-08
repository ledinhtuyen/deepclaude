module "cloudrun" {
  source = "../../modules/cloudrun"

  project_id          = var.project_id
  region              = var.region
  deepclaude_version  = var.deepclaude_version
  cloud_run_ingress   = var.cloud_run_ingress
  nginx_repository_id = var.nginx_repository_id
  web_repository_id   = var.web_repository_id
  api_repository_id   = var.api_repository_id
  secret_key          = var.secret_key
  vpc_network_name    = module.network.vpc_network_name
  vpc_subnet_name     = module.network.vpc_subnet_name
}

module "network" {
  source = "../../modules/network"

  project_id = var.project_id
  region     = var.region
}

module "registry" {
  source = "../../modules/registry"

  project_id          = var.project_id
  region              = var.region
  nginx_repository_id = var.nginx_repository_id
  web_repository_id   = var.web_repository_id
  api_repository_id   = var.api_repository_id
}

locals {
  services = [
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "run.googleapis.com",
  ]
}

resource "google_project_service" "enabled_services" {
  for_each = toset(local.services)
  project  = var.project_id
  service  = each.value
}
