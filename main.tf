module "service_account" {
  source    = "ptonini/service-account/kubernetes"
  version   = "~> 1.1.0"
  name      = var.username
  namespace = "kube-system"
  cluster_role_rules = [
    {
      api_groups = ["rbac.authorization.k8s.io"]
      resources  = ["roles", "clusterroles", "rolebindings", "clusterrolebindings"]
      verbs      = ["*"]
    },
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
    ca_cert     = module.service_account.ca_crt
    token       = module.service_account.token
    default_ttl = var.default_ttl
    max_ttl     = var.max_ttl
  })
}

resource "vault_generic_endpoint" "rotate_root" {
  path                 = "${module.vault_mount.this.path}/rotate-root"
  ignore_absent_fields = true
  disable_read         = true
  disable_delete       = true
  data_json = "{}"
  depends_on = [
    vault_generic_endpoint.this
  ]
}