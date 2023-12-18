resource "vault_kubernetes_secret_backend" "this" {
  path                      = var.path
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds     = var.max_lease_ttl_seconds
  kubernetes_host           = var.kubernetes_host
  kubernetes_ca_cert        = var.kubernetes_ca_cert
  service_account_jwt       = var.service_account_jwt
  disable_local_ca_jwt      = var.disable_local_ca_jwt
}

resource "vault_kubernetes_secret_backend_role" "this" {
  for_each                      = var.roles
  backend                       = vault_kubernetes_secret_backend.this.path
  name                          = coalesce(each.value.name, each.key)
  allowed_kubernetes_namespaces = each.value.allowed_kubernetes_namespaces
  token_max_ttl                 = each.value.token_max_ttl
  token_default_ttl             = each.value.token_default_ttl
  service_account_name          = each.value.service_account_name
  kubernetes_role_name          = each.value.kubernetes_role_name
  kubernetes_role_type          = each.value.kubernetes_role_type
  extra_labels                  = each.value.extra_labels
  extra_annotations             = each.value.extra_annotations
}