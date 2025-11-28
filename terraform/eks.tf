resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster_role.arn

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = "true"
  }
  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = var.service_ipv4_cidr
  }
  upgrade_policy {
    support_type = "STANDARD"
  }
  vpc_config {
    endpoint_private_access = "false"
    endpoint_public_access  = "true"
    public_access_cidrs     = ["0.0.0.0/0"]
    security_group_ids      = [aws_security_group.eks_cluster.id]
    subnet_ids              = local.filtered_subnets
  }
  zonal_shift_config {
    enabled = "true"
  }
  tags = {
    Name                                   = var.cluster_name
    "alpha.eksctl.io/cluster-oidc-enabled" = "true"
  }
}

# resource "aws_eks_addon" "aws_ebs_csi_driver" {
#   cluster_name             = aws_eks_cluster.eks.name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.53.0-eksbuild.1"
#   service_account_role_arn = aws_iam_role.ebs_csi_role.arn
#   configuration_values = jsonencode({
#     tolerations = [{
#       key      = "purpose"
#       operator = "Equal"
#       value    = "critical-apps"
#     }]
#   })
# }

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_launch_template" "eks_bottlerocket" {
  name                   = "lt-eks-bottlerocket"
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted             = true
      delete_on_termination = true
      volume_size           = var.disk_size
      volume_type           = "gp3"
    }
  }
}

resource "aws_eks_node_group" "critical-apps" {
  node_group_name = "critical-apps"
  cluster_name    = aws_eks_cluster.eks.name
  version         = aws_eks_cluster.eks.version
  ami_type        = var.ami_graviton
  instance_types  = ["t4g.medium"]
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = local.filtered_subnets
  launch_template {
    id      = aws_launch_template.eks_bottlerocket.id
    version = "$Latest"
  }
  taint {
    key    = "purpose"
    value  = "critical-apps"
    effect = "NO_SCHEDULE"
  }
  scaling_config {
    desired_size = "2"
    max_size     = "2"
    min_size     = "2"
  }
  update_config {
    max_unavailable = "1"
  }
  labels = {
    purpose = "critical-apps"
  }
  tags = {
    Name                     = "critical-apps"
    "karpenter.sh/discovery" = var.cluster_name
  }
}

# Obtém o Security Group padrão criado pelo EKS
data "aws_security_group" "eks_cluster_sg" {
  id = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}

# Aplica a tag necessária (sem recriar o recurso)
resource "aws_ec2_tag" "eks_cluster_discovery_tag" {
  resource_id = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id

  key   = "karpenter.sh/discovery"
  value = var.cluster_name
}
