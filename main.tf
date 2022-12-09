locals {
  certificate_rules = [
    {
      api_groups = ["certificates.k8s.io"]
      resources  = ["certificatesigningrequests", "certificatesigningrequests/approval"]
      verbs      = ["*"]
    },
    {
      api_groups    = ["certificates.k8s.io"]
      resources     = ["signers"]
      resourceNames = ["kubernetes.io/kube-apiserver-client"]
      verbs         = ["approve", "sign"]
    }
  ]
  serviceaccount_rules = [
    {
      api_groups : [""]
      resources : ["serviceaccounts", "secrets"]
      verbs : ["*"]
    }
  ]
  all_rules = concat(
    [
      {
        api_groups = ["rbac.authorization.k8s.io"]
        resources  = ["roles", "clusterroles", "rolebindings", "clusterrolebindings"]
        verbs      = ["*"]
      }
    ],
    var.certificate_generation ? local.certificate_rules : [],
    var.serviceaccount_generation ? local.serviceaccount_rules : []
  )
}

module "service_account" {
  source             = "ptonini/service-account/kubernetes"
  version            = "~> 1.1.0"
  count              = var.credentials == "service_account" ? 1 : 0
  name               = var.username
  namespace          = "kube-system"
  cluster_role_rules = local.all_rules
  providers = {
    kubernetes = kubernetes
  }
}

module "certificate" {
  source             = "ptonini/user-certificate/kubernetes"
  version            = "~> 1.0.0"
  count              = var.credentials == "certificate" ? 1 : 0
  name               = var.username
  cluster_role_rules = local.all_rules
  providers = {
    kubernetes = kubernetes
  }
}

module "vault_mount" {
  source  = "ptonini/mount/vault"
  version = "~> 1.0.0"
  path    = var.path
  type    = var.type
}

resource "vault_generic_endpoint" "this" {
  path                 = "${module.vault_mount.this.path}/config"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true
  data_json = jsonencode({
    host        = var.host
    ca_cert     = try(module.service_account[0].ca_crt, var.ca_cert)
    token       = try(module.service_account[0].token, var.token)
    client_cert = try(module.certificate[0].this.certificate, var.client_cert)
    client_key  = try(module.certificate[0].private_key.private_key_pem, var.client_key)
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
  })
}

resource "vault_generic_endpoint" "rotate_root" {
  count                = var.rotate_root ? 1 : 0
  path                 = "${module.vault_mount.this.path}/rotate-root"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true
  data_json            = "{}"
  depends_on = [
    vault_generic_endpoint.this
  ]
}