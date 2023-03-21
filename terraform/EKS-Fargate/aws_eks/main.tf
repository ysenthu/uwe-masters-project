resource "aws_cloudwatch_log_group" "cluster_logs" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
  tags              = var.tags
}

resource "aws_eks_cluster" "this" {
  name                      = var.cluster_name
  enabled_cluster_log_types = var.cluster_enabled_log_types
  role_arn                  = local.cluster_iam_role_arn
  tags                      = var.tags

  vpc_config {
    subnet_ids              = var.subnets
  }

  depends_on = [
    aws_cloudwatch_log_group.cluster_logs
  ]
}

resource "null_resource" "wait_for_cluster" {

  depends_on = [
    aws_eks_cluster.this,
  ]

  provisioner "local-exec" {
    command     = var.wait_for_cluster_cmd
    interpreter = var.wait_for_cluster_interpreter
    environment = {
      ENDPOINT = aws_eks_cluster.this.endpoint
    }
  }
}

resource "aws_iam_role" "cluster" {
  name_prefix           = var.cluster_name
  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role_policy.json
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = local.cluster_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = local.cluster_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceControllerPolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSVPCResourceController"
  role       = local.cluster_iam_role_name
}

resource "aws_iam_role" "eks_fargate_pod" {
  name_prefix          = format("%s-fargate", var.cluster_name)
  assume_role_policy   = data.aws_iam_policy_document.eks_fargate_pod_assume_role.json
  tags                 = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_fargate_pod" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks_fargate_pod.name
}

resource "aws_eks_fargate_profile" "this" {
  for_each               = local.fargate_profiles_expanded 
  cluster_name           = var.cluster_name
  fargate_profile_name   = lookup(each.value, "name", format("%s", replace(each.key, "_", "-")))
  subnet_ids             = lookup(each.value, "subnets", var.subnets)
  pod_execution_role_arn = local.pod_execution_role_arn
  tags                   = each.value.tags
  selector {
    namespace = each.value.namespace
    labels    = lookup(each.value, "labels", null)
  }

  depends_on = [aws_eks_cluster.this]
}
