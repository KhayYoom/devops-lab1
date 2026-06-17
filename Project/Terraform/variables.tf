variable "resource_group_name" {
  default = "rg-fastapi-dev"
}

variable "location" {
  default = "Central India"
}

variable "acr_name" {
  default = "fastapiacrkhayyoom"
}

variable "log_analytics_name" {
  default = "law-fastapi-dev"
}

variable "container_app_env_name" {
  default = "cae-fastapi-dev"
}

variable "container_app_name" {
  default = "fastapi-app"
}

variable "image_name" {
  default = "fastapi-app"
}

variable "image_tag" {
  description = "Container image tag to deploy (set by CI to the commit SHA)."
  default     = "latest"
}