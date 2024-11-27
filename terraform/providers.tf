# Necesario para poder tener el bucket en un archivo diferente*
# Terraform carga todos los archivos automáticamente!
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
  }
}

provider "aws" {
  region = var.region
}