resource "aws_eks_cluster" "eks" {
  name       = var.cluster_name
  version    = var.cluster_version
  role_arn   = aws_iam_role.cluster_role.arn
  access_config {
    authentication_mode                         = "CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = "true"
  }
  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = var.service_ipv4_cidr
  }
  vpc_config {
    endpoint_private_access = "false"
    endpoint_public_access  = "true"
    public_access_cidrs     = ["0.0.0.0/0"]
    # security_group_ids      = var.security_groups
    subnet_ids = local.filtered_subnets
  }
  tags = {
    Name                                   = var.cluster_name
    "alpha.eksctl.io/cluster-oidc-enabled" = "true"
  }
}

resource "aws_iam_openid_connect_provider" "eks_cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}


resource "aws_eks_node_group" "critical-apps" {
  node_group_name = "critical-apps"
  cluster_name    = aws_eks_cluster.eks.name
  ami_type        = var.ami_graviton
  disk_size       = var.disk_size
  instance_types  = ["t4g.medium"]
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = local.filtered_subnets
  taint {
    key    = "purpose"
    value  = "critical-apps"
    effect = "NO_SCHEDULE"
  }
  scaling_config {
    desired_size = "2"
    min_size     = "2"
    max_size     = "2"
  }
  update_config {
    max_unavailable = "1"
  }
  labels = {
    purpose = "critical-apps"
  }
  tags = {
    Name      = "critical-apps"
    Processor = "graviton"
  }
}
