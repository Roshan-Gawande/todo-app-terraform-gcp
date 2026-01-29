variable "project_id" {
  description = "The ID of the Google Cloud project"
}

variable "region" {
  description = "The region to deploy the resources to"
  default     = "us-central1"
}

variable "zone" {
  description = "The zone to deploy the resources to"
  default     = "us-central1-a"
}

variable "credentials" {
  description = "The path to the service account key file"
}

variable "authorized_network_ip" {
  description = "The IP address authorized to access the database"
  type        = string
  default     = null
}

variable "github_repo_url" {
  description = "The URL of the GitHub repository containing the application code"
  type        = string
}

# Backend VM Configuration
variable "backend_vm_name" {
  description = "The name of the backend VM"
  type        = string
}

variable "backend_machine_type" {
  description = "The machine type for the backend VM"
  type        = string
}

variable "backend_image" {
  description = "The OS image for the backend VM"
  type        = string
}

# Frontend VM Configuration
variable "frontend_vm_name" {
  description = "The name of the frontend VM"
  type        = string
}

variable "frontend_machine_type" {
  description = "The machine type for the frontend VM"
  type        = string
}

variable "frontend_image" {
  description = "The OS image for the frontend VM"
  type        = string
}

variable "database_name" {
  description = "The name of the database"
  type        = string
}

variable "database_user" {
  description = "The username for the database"
  type        = string
}

variable "database_password" {
  description = "The password for the database"
  type        = string
}


