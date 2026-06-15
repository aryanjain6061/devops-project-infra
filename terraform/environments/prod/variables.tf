variable "aws_region"          { type = string  default = "ap-south-1" }
variable "project_name"        { type = string  default = "devops-project" }
variable "environment"         { type = string  default = "prod" }
variable "vpc_cidr"            { type = string  default = "10.0.0.0/16" }
variable "availability_zones"  { type = list(string) }
variable "github_org"          { type = string }
variable "kubernetes_version"  { type = string  default = "1.29" }
variable "node_instance_types" { type = list(string) default = ["t3.medium"] }
variable "node_desired_size"   { type = number  default = 2 }
variable "node_min_size"       { type = number  default = 1 }
variable "node_max_size"       { type = number  default = 5 }
