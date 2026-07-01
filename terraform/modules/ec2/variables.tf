variable "project_name"          { type = string }
variable "environment"           { type = string }
variable "ami_id"                { type = string }
variable "master_instance_type"  { type = string  default = "t3.medium" }
variable "worker_instance_type"  { type = string  default = "t3.medium" }
variable "worker_count"          { type = number  default = 2 }
variable "public_subnet_id"      { type = string }
variable "private_subnet_ids"    { type = list(string) }
variable "master_sg_id"          { type = string }
variable "worker_sg_id"          { type = string }
variable "kms_key_arn"           { type = string }
variable "instance_profile_name" { type = string }
variable "ssh_public_key_path"   { type = string  default = "~/.ssh/id_rsa.pub" }
