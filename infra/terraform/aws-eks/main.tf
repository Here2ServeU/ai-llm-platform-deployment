
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.55" }
  }
}
provider "aws" { region = var.region }

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.7"
  name = "${var.name}-vpc"
  cidr = var.vpc_cidr
  azs  = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = var.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8"
  cluster_name    = var.name
  cluster_version = var.kubernetes_version
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_irsa = true
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.large"]
      desired_size = 2
      min_size = 1
      max_size = 3
    }
  }
  tags = var.tags
}

output "kubeconfig" {
  value = "aws eks update-kubeconfig --region ${var.region} --name ${var.name}"
}
