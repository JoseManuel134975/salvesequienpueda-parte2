# variable "region" {
#   description = "La región de AWS donde se desplegará la infraestructura"
#   default     = "us-east-1"
# }

# Variable definida
variable "region" {
  description = "Región donde se despliega la insfraestructura de AWS"
  type = string
}