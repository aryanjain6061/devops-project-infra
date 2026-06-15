variable "project_name"              { type = string }
variable "environment"               { type = string }
variable "kubernetes_version"        { type = string  default = "1.29" }
variable "cluster_role_arn"          { type = string }
variable "node_role_arn"             { type = string }
variable "private_subnet_ids"        { type = list(string) }
variable "cluster_security_group_id" { type = string }
variable "kms_key_arn"               { type = string }
variable "node_instance_types"       { type = list(string) default = ["t3.medium"] }
variable "node_desired_size"         { type = number  default = 2 }
variable "node_min_size"             { type = number  default = 1 }
variable "node_max_size"             { type = number  default = 5 }
