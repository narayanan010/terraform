locals {
  k8s_namespace = var.namespace


  k8s_role_admin         = "${var.namespace}-admin-role"
  k8s_role_admin_binding = "${var.namespace}-admin-role-binding"
  k8s_user_admin         = "${var.namespace}-${var.stage}-admin-user"

  k8s_role_readonly         = "${var.namespace}-ro-role"
  k8s_role_readonly_binding = "${var.namespace}-ro-role-binding"
  k8s_user_readonly         = "${var.namespace}-${var.stage}-ro-user"

  k8s_role_basicuser         = "${var.namespace}-basicuser-role"
  k8s_role_basicuser_binding = "${var.namespace}-basicuser-role-binding"
  k8s_user_basicuser         = "${var.namespace}-${var.stage}-basicuser"

  k8s_role_deployer         = "${var.namespace}-deployer-role"
  k8s_role_deployer_binding = "${var.namespace}-deployer-role-binding"
  k8s_user_deployer         = "${var.namespace}-${var.stage}-deployer-user"
}

# NAMESPACE
######################################################
resource "kubernetes_namespace" "k8s_namespace" {
  metadata {
    name = local.k8s_namespace
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Kubernetes Roles
######################################################

## ADMIN
resource "kubernetes_role" "admin_roles" {
  metadata {
    name      = local.k8s_role_admin
    namespace = local.k8s_namespace
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [kubernetes_namespace.k8s_namespace]
}

## ADMIN
resource "kubernetes_role_binding" "admin_role_binding" {
  metadata {
    name      = local.k8s_role_admin_binding
    namespace = local.k8s_namespace
  }

  role_ref {
    kind      = "Role"
    name      = local.k8s_role_admin
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = local.k8s_user_admin
    namespace = ""
    api_group = "rbac.authorization.k8s.io"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## READONLY
resource "kubernetes_role" "readonly_roles" {
  metadata {
    name      = local.k8s_role_readonly
    namespace = local.k8s_namespace
  }

  rule {
    api_groups = ["*"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods/log"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["cronjobs"]
    verbs      = ["list", "get", "watch"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["jobs"]
    verbs      = ["list", "get", "watch"]
  }

  depends_on = [kubernetes_namespace.k8s_namespace]
}

resource "kubernetes_role_binding" "readonly_role_binding" {
  metadata {
    name      = local.k8s_role_readonly_binding
    namespace = local.k8s_namespace
  }
  role_ref {
    kind      = "Role"
    name      = local.k8s_role_readonly
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = local.k8s_user_readonly
    namespace = ""
    api_group = "rbac.authorization.k8s.io"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## BASIC
resource "kubernetes_role" "basicuser_roles" {
  metadata {
    name      = local.k8s_role_basicuser
    namespace = local.k8s_namespace
  }

  rule {
    api_groups = ["*"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["patch", "get", "watch", "list", "create", "update"]
  }

  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["patch", "get", "watch", "list", "create", "update"]
  }

  rule {
    api_groups = ["*"]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch"]
  }

  depends_on = [kubernetes_namespace.k8s_namespace]
}

resource "kubernetes_role_binding" "basicuser_role_binding" {
  metadata {
    name      = local.k8s_role_basicuser_binding
    namespace = local.k8s_namespace
  }
  role_ref {
    kind      = "Role"
    name      = local.k8s_role_basicuser
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = local.k8s_user_basicuser
    namespace = ""
    api_group = "rbac.authorization.k8s.io"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## DEPLOYER
resource "kubernetes_role" "deployer_roles" {
  metadata {
    name      = local.k8s_role_deployer
    namespace = local.k8s_namespace
  }
  rule {
    api_groups = ["*"]
    resources  = ["deployments"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["patch", "get", "watch", "list", "create", "update", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["secrets"]
    verbs      = ["patch", "get", "watch", "list", "create", "update", "delete"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["pods"]
    verbs      = ["list", "get", "watch", "create", "delete"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["ingresses"]
    verbs      = ["list", "get", "watch", "delete", "create", "update", "patch"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["configmaps"]
    verbs      = ["list", "get", "watch", "delete", "create", "update", "patch"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["cronjobs", "jobs"]
    verbs      = ["list", "get", "watch", "delete", "create", "update", "patch"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["persistentvolumeclaims"]
    verbs      = ["list", "get", "watch", "delete", "create", "patch"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["list", "get", "watch", "delete", "create", "patch"]
  }
  rule {
    api_groups = [""]
    resources  = ["serviceaccounts"]
    verbs      = ["patch", "get", "watch", "list", "create", "update", "delete"]
  }
  rule {
    api_groups = ["secrets-store.csi.x-k8s.io"]
    resources  = ["secretproviderclasses"]
    verbs      = ["patch", "get", "watch", "list", "create", "update", "delete"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["poddisruptionbudgets"]
    verbs      = ["patch", "get", "watch", "list", "create", "update", "delete"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["replicasets"]
    verbs      = ["patch", "get", "watch", "list", "create", "update", "delete"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["events"]
    verbs      = ["patch", "get", "watch", "list", "create", "update", "delete"]
  }
  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["patch", "get", "watch", "list", "create", "update", "delete"]
  }

  depends_on = [kubernetes_namespace.k8s_namespace]
}


# Kubernetes Role Bindings
######################################################
## DEPLOYER
resource "kubernetes_role_binding" "deployer_role_binding" {
  metadata {
    name      = local.k8s_role_deployer_binding
    namespace = local.k8s_namespace
  }
  role_ref {
    kind      = "Role"
    name      = local.k8s_role_deployer
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = local.k8s_user_deployer
    namespace = ""
    api_group = "rbac.authorization.k8s.io"
  }
  lifecycle {
    create_before_destroy = true
  }
}
