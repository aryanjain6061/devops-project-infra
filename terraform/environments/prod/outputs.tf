output "master_public_ip"        { value = module.ec2.master_public_ip }
output "master_private_ip"       { value = module.ec2.master_private_ip }
output "worker_private_ips"      { value = module.ec2.worker_private_ips }
output "ecr_repository_url"      { value = module.ecr.repository_url }
output "github_actions_role_arn" { value = module.iam.github_actions_role_arn }
output "vpc_id"                  { value = module.vpc.vpc_id }
