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
  default = "vault-backend"
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

variable "rotate_root" {
  default = false
}

variable "serviceaccount_generation" {
  default = false
}

variable "certificate_generation" {
  default = true
}

variable "create_bindings" {
  default = false
}