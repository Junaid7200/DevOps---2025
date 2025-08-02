# terraform/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "app_network" {
  name = "student_app_network"
}

resource "docker_volume" "postgres_data" {
  name = "student_app_postgres_data"
}

resource "docker_volume" "prometheus_data" {
  name = "student_app_prometheus_data"
}

resource "docker_volume" "grafana_data" {
  name = "student_app_grafana_data"
}

resource "docker_image" "postgres" {
  name = "postgres:15"
}

resource "docker_image" "backend" {
  name = "student-app-backend:latest"
  build {
    context = "../backend"
  }
}

resource "docker_image" "frontend" {
  name = "student-app-frontend:latest"
  build {
    context = "../frontend"
  }
}

resource "docker_container" "db" {
  name  = "student-app-db"
  image = docker_image.postgres.image_id
  
  env = [
    "POSTGRES_DB=postgres",
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=postgres"
  ]
  
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  ports {
    internal = 5432
    external = 5433
  }
}

resource "docker_container" "backend" {
  name  = "student-app-backend"
  image = docker_image.backend.image_id
  
  env = [
    "DEBUG=1"
  ]
  
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  ports {
    internal = 8000
    external = 8000
  }
  
  depends_on = [docker_container.db]
}

resource "docker_container" "frontend" {
  name  = "student-app-frontend"
  image = docker_image.frontend.image_id
  
  networks_advanced {
    name = docker_network.app_network.name
  }
  
  ports {
    internal = 5173
    external = 5173
  }
  
  depends_on = [docker_container.backend]
}