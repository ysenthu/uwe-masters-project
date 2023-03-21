locals {
  cluster_iam_role_name             =  join("", aws_iam_role.cluster.*.name) 
  cluster_iam_role_arn              =  join("", aws_iam_role.cluster.*.arn) 
  policy_arn_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
  pod_execution_role_arn  =  element(concat(aws_iam_role.eks_fargate_pod.*.arn, list("")), 0) 
  pod_execution_role_name =  element(concat(aws_iam_role.eks_fargate_pod.*.name, list("")), 0) 

  fargate_profiles_expanded = { for k, v in var.fargate_profiles : k => merge(v,{ tags = merge(var.tags, lookup(v, "tags", {})) },) }

}