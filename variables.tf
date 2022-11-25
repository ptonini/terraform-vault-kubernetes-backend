variable "path" {}

variable "type" {
  default = "kubernetes_v2"
}

variable "host" {}

variable "user_certificate_name" {
  default = "vault-secrets-backend"
}

variable "ca_cert" {}

variable "default_ttl" {
  default = null
}

variable "max_ttl" {
  default = null
}

variable "vault_token" {}