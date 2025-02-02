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
