module "user_certificate" {
  source = "github.com/ptonini/terraform-kubernetes-user-certificate"
  name = var.user_certificate_name
  cluster_role_rules = [
    {
      api_groups = ["rbac.authorization.k8s.io"]
      resources = ["roles", "clusterroles", "rolebindings", "clusterrolebindings"]
      verbs = ["*"]
    },
    {
      api_groups = ["certificates.k8s.io"]
      resources = ["certificatesigningrequests", "certificatesigningrequests/approval"]
      verbs = ["*"]
    },
    {
      api_groups = ["certificates.k8s.io"]
      resources = ["signers"]
      resourceNames = ["kubernetes.io/kube-apiserver-client"]
      verbs = ["approve", "sign" ]
    }
  ]
  providers = {
    kubernetes = kubernetes
  }
}

module "vault_mount"{
  source = "github.com/ptonini/terraform-vault-mount"
  path = var.path
  type = var.type
}

resource "vault_generic_endpoint" "config" {
  path = "${module.vault_mount.this.path}/config"
  ignore_absent_fields = true
  disable_read = true
  disable_delete = true
  data_json = jsonencode({
    host = var.host
    ca_cert = var.ca_cert
    client_cert = module.user_certificate.this.certificate
    client_key = module.user_certificate.private_key.private_key_pem
    default_ttl = var.default_ttl
    max_ttl = var.max_ttl
  })
}