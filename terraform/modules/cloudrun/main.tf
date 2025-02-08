resource "google_service_account" "deepclaude_service_account" {
  account_id   = "deepclaude-service-account"
  display_name = "Deepclaude Service Account"
}

resource "google_project_iam_member" "deepclaude_service_account_role" {
  for_each = toset([
    "roles/run.admin",
  ])
  project = var.project_id
  member  = "serviceAccount:${google_service_account.deepclaude_service_account.email}"
  role    = each.value
}

resource "google_cloud_run_v2_service" "deepclaude_service" {
  name     = "deepclaude-service"
  location = var.region
  ingress  = var.cloud_run_ingress
  template {
    service_account = google_service_account.deepclaude_service_account.email
    containers {
      name  = "nginx"
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.nginx_repository_id}/deepclaude-nginx:latest"
      resources {
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
      }
      ports {
        name           = "http1"
        container_port = 80
      }
      depends_on = ["deepclaude-web", "deepclaude-api"]
      startup_probe {
        timeout_seconds   = 240
        period_seconds    = 240
        failure_threshold = 1
        tcp_socket {
          port = 80
        }
      }
    }
    containers {
      name  = "deepclaude-api"
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.api_repository_id}/deepclaude-api:${var.deepclaude_version}"
      resources {
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
      }
      env {
        name  = "PORT"
        value = 1337
      }
      env {
        name  = "MODE"
        value = "api"
      }
      env {
        name  = "SECRET_KEY"
        value = var.secret_key
      }
      env {
        name  = "LOG_LEVEL"
        value = "INFO"
      }
      env {
        name  = "WEB_API_CORS_ALLOW_ORIGINS"
        value = "*"
      }

      startup_probe {
        timeout_seconds   = 240
        period_seconds    = 240
        failure_threshold = 1
        tcp_socket {
          port = 1337
        }
      }
    }
    containers {
      name  = "deepclaude-web"
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.web_repository_id}/deepclaude-web:${var.deepclaude_version}"
      resources {
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
      }
      env {
        name  = "PORT"
        value = 3000
      }
      startup_probe {
        timeout_seconds   = 240
        period_seconds    = 240
        failure_threshold = 1
        tcp_socket {
          port = 3000
        }
      }
    }
    vpc_access {
      connector = "projects/${var.project_id}/locations/${var.region}/connectors/${google_vpc_access_connector.connector.name}"
      egress    = "ALL_TRAFFIC"
    }
    scaling {
      min_instance_count = 1
      max_instance_count = 3
    }
  }
}

resource "google_cloud_run_service_iam_binding" "default" {
  location = google_cloud_run_v2_service.deepclaude_service.location
  service  = google_cloud_run_v2_service.deepclaude_service.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}

resource "google_vpc_access_connector" "connector" {
  name          = "cloud-run-connector"
  region        = var.region
  min_instances = 2
  max_instances = 3
  subnet {
    name = var.vpc_subnet_name
  }
}

output "deepclaude_service_name" {
  value = google_cloud_run_v2_service.deepclaude_service.name
}