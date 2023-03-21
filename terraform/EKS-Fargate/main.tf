provider "aws" {
  region = "us-east-1"
  profile = "educate"
}

module "vpc"{
    source = "./aws_vpc"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "test-vpc"
    azs = ["us-east-1a","us-east-1b"]
    priv_subnets_cidr = ["10.0.1.0/24","10.0.2.0/24"]
    pub_subnets_cidr = ["10.0.3.0/24","10.0.4.0/24"]
}


module "eks_cluster" {
    source = "./aws_eks"
    subnets =  module.vpc.priv_subnets
    fargate_profiles = {"default-fp" = {"namespace"="kube-system"},"dev-fp" =  {"namespace" = "development"}} 
    depends_on = [ module.vpc ] #Optional only required if your needing the vpc module 
}
