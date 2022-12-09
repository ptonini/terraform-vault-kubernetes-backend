variable "path" {}

variable "type" {
  default = "kubernetes_v2"
}

variable "host" {}

variable "credentials" {
  type    = string
  default = "none"
}

variable "username" {
  default = "vault-secrets-backend"
}

variable "token" {
  default = null
}

variable "ca_cert" {
  default = null
}

variable "client_cert" {
  default = null
}

variable "client_key" {
  default = null
}

variable "default_ttl" {
  default = null
}

variable "max_ttl" {
  default = null
}
