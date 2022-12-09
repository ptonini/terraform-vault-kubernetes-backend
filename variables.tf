variable "path" {}

variable "type" {
  default = "kubernetes_v2"
}

variable "host" {}

variable "username" {
  default = "vault-secrets-backend"
}

variable "default_ttl" {
  default = null
}

variable "max_ttl" {
  default = null
}
