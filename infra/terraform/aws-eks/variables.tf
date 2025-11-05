
variable "region" { type = string, default = "us-east-1" }
variable "name"   { type = string, default = "llm-eks" }
variable "kubernetes_version" { type = string, default = "1.29" }
variable "vpc_cidr" { type = string, default = "10.60.0.0/16" }
variable "azs" { type = list(string), default = ["us-east-1a","us-east-1b"] }
variable "public_subnets" { type = list(string), default = ["10.60.0.0/20","10.60.16.0/20"] }
variable "private_subnets" { type = list(string), default = ["10.60.32.0/20","10.60.48.0/20"] }
variable "tags" { type = map(string), default = { Project = "ai-llm", Env = "dev" } }
