# Cluster and Karpenter
resource "aws_iam_role" "cluster_role" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

resource "aws_iam_role" "node_role" {
  name               = "${var.cluster_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

resource "aws_iam_role" "karpenter_node_role" {
  name               = "KarpenterNodeRole-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

resource "aws_iam_role" "karpenter_controller_role" {
  name               = "KarpenterControllerRole-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_role_assume_role.json
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name   = "KarpenterControllerPolicy-${var.cluster_name}"
  policy = data.aws_iam_policy_document.karpenter_controller_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_role_policies_attachment" {
  for_each   = toset(var.cluster_policies_arn)
  role       = aws_iam_role.cluster_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "node_role_policies_attachment" {
  for_each   = toset(var.node_policies_arn)
  role       = aws_iam_role.node_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "karpenter_node_role_policies_attachment" {
  for_each   = toset(var.karpenter_node_policies_arn)
  role       = aws_iam_role.karpenter_node_role.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_role_policies_attachment" {
  role       = aws_iam_role.karpenter_controller_role.name
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
}

resource "aws_iam_role" "aws_ebs_csi_driver" {
  name               = var.aws_ebs_csi_driver_role
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ebs_policy_attach" {
  role       = aws_iam_role.aws_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# Services

## External DNS
resource "aws_iam_role" "external_dns" {
  name               = var.external_dns_role
  assume_role_policy = data.aws_iam_policy_document.externaldns_assume_role.json
}

resource "aws_iam_role_policy" "external_dns" {
  name   = var.external_dns_policy
  role   = aws_iam_role.external_dns.id
  policy = data.aws_iam_policy_document.externaldns_policy.json
}

## External Secret
resource "aws_iam_role" "external_secret" {
  name               = var.external_secret_role
  assume_role_policy = data.aws_iam_policy_document.externalsecret_assume_role.json
}

resource "aws_iam_role_policy" "external_secret" {
  name   = var.external_secret_policy
  role   = aws_iam_role.external_secret.id
  policy = data.aws_iam_policy_document.externalsecret_policy.json
}

## Crossplane
resource "aws_iam_user" "crossplane" {
  name = "crossplane"
}

resource "aws_iam_access_key" "crossplane" {
  user = aws_iam_user.crossplane.name
}

resource "aws_iam_user_policy" "crossplane" {
  name   = var.crossplane_policy
  user   = aws_iam_user.crossplane.name
  policy = data.aws_iam_policy_document.crossplane_policy.json
}

## Cert Manager
resource "aws_iam_role" "cert_manager" {
  name               = var.cert_manager_role
  assume_role_policy = data.aws_iam_policy_document.certmanager_assume_role.json
}

resource "aws_iam_role_policy" "cert_manager" {
  name   = var.cert_manager_policy
  role   = aws_iam_role.cert_manager.id
  policy = data.aws_iam_policy_document.certmanager_policy.json
}

## Velero
resource "aws_iam_role" "velero" {
  name               = var.velero_role
  assume_role_policy = data.aws_iam_policy_document.velero_assume_role.json
}

resource "aws_iam_role_policy" "velero" {
  name   = var.velero_policy
  role   = aws_iam_role.velero.id
  policy = data.aws_iam_policy_document.velero_policy.json
}

## Loki
resource "aws_iam_role" "loki" {
  name               = var.loki_role
  assume_role_policy = data.aws_iam_policy_document.loki_assume_role.json
}

resource "aws_iam_role_policy" "loki" {
  name   = var.loki_policy
  role   = aws_iam_role.loki.id
  policy = data.aws_iam_policy_document.loki_policy.json
}
