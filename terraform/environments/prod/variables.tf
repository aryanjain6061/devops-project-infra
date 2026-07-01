variable "aws_region"           { type = string  default = "ap-south-1" }
variable "project_name"         { type = string  default = "devops-project" }
variable "environment"          { type = string  default = "prod" }
variable "vpc_cidr"             { type = string  default = "10.0.0.0/16" }
variable "availability_zones"   { type = list(string) }
variable "github_org"           { type = string }
variable "allowed_ssh_cidr"     { type = string }
variable "ami_id"               { type = string }
variable "master_instance_type" { type = string  default = "t3.medium" }
variable "worker_instance_type" { type = string  default = "t3.medium" }
variable "worker_count"         { type = number  default = 2 }
variable "ssh_public_key_path"  { type = string  default = "~/.ssh/id_rsa.pub" }
