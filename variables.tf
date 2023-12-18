variable "path" {}

variable "kubernetes_host" {}

variable "service_account_jwt" {}

variable "kubernetes_ca_cert" {}

variable "disable_local_ca_jwt" {
  default = false
}

variable "default_lease_ttl_seconds" {
  default = null
}

variable "max_lease_ttl_seconds" {
  default = null
}

variable "roles" {
  type = map(object({
    name                          = optional(string)
    allowed_kubernetes_namespaces = optional(set(string), ["*"])
    token_max_ttl                 = optional(number)
    token_default_ttl             = optional(number)
    service_account_name          = optional(string)
    kubernetes_role_name          = optional(string)
    kubernetes_role_type          = optional(string)
    generated_role_rules          = optional(string)
    extra_labels                  = optional(map(string))
    extra_annotations = optional(map(string))
  }))
  default = {}
}



#variable "type" {
#  default = "kubernetes_v2"
#}
#
#variable "host" {}
#
#variable "credentials" {
#  type    = string
#  default = "none"
#}
#
#variable "username" {
#  default = "vault-backend"
#}
#
#variable "token" {
#  default = null
#}
#
#variable "ca_cert" {
#  default = null
#}
#
#variable "client_cert" {
#  default = null
#}
#
#variable "client_key" {
#  default = null
#}
#
#variable "default_ttl" {
#  default = null
#}
#
#variable "max_ttl" {
#  default = null
#}
#
#variable "rotate_root" {
#  default = false
#}
#
#variable "serviceaccount_generation" {
#  default = false
#}
#
#variable "certificate_generation" {
#  default = true
#}
#
#variable "create_bindings" {
#  default = false
#}