variable "cluster_name"{
  default = "eks-standard-cluster"
  type = string
}
variable "cluster_enabled_log_types" {
  default     = []
  description = "A list of the desired control plane logging to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}
variable "tags" {
  default = {"Name":"Upwork"}
  description = "Map of the Tags to tag the resources created by this terraform module"
  type = map
}

variable "subnets" {
  type = list(string)
  description = "List of the Private Subnets to create cluster on"

}
variable "wait_for_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
  type        = string
  default     = "for i in `seq 1 60`; do if `command -v wget > /dev/null`; then wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; else curl -k -s $ENDPOINT/healthz >/dev/null && exit 0 || true;fi; sleep 5; done; echo TIMEOUT && exit 1"
}

variable "wait_for_cluster_interpreter" {
  description = "Custom local-exec command line interpreter for the command to determining if the eks cluster is healthy."
  type        = list(string)
  default     = ["/bin/sh", "-c"]
}

#Specify the fargate profile as map of maps
#For an example {"default-fp" = {"namespace"="kube-system"},"dev-fp" = {"namespace" = "development"}} 

variable "fargate_profiles" {
  description = "Fargate profiles to create."
  type        = any
  default     = {}
}
