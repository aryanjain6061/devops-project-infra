variable "project_name"          { type = string }
variable "environment"           { type = string }
variable "github_org"            { type = string }
variable "eks_cluster_name"      { type = string  default = "" }
variable "eks_cluster_dependency"{ type = any     default = null }
