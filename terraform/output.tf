output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "kubecontext" {
  value = "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/${aws_eks_cluster.eks.name}"
}

output "roles_arns" {
  value = {
    karpenter_controller_role_arn = aws_iam_role.karpenter_controller_role.arn
    karpenter_node_role_arn       = aws_iam_role.karpenter_node_role.arn
    external_dns_role_arn         = aws_iam_role.external_dns.arn
    external_secret_role_arn      = aws_iam_role.external_secret.arn
    cert_manager_role_arn         = aws_iam_role.cert_manager.arn
    velero_role_arn               = aws_iam_role.velero.arn
    loki_role_arn                 = aws_iam_role.loki.arn
    aws_ebs_csi_driver_role_arn   = aws_iam_role.aws_ebs_csi_driver.arn
  }
}

output "db_secret_name" {
  value = regex("secret:(.+)-[^-]+$", aws_db_instance.rds.master_user_secret[0].secret_arn)[0]
}

output "bucket_names" {
  value = [for b in aws_s3_bucket.buckets : b.bucket]
}

output "db_host" {
  value = aws_db_instance.rds.address
}
