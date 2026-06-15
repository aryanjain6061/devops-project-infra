# ── KMS (encrypt everything) ──────────────────────────────────────
module "kms" {
  source       = "../../modules/kms"
  project_name = var.project_name
  environment  = var.environment
}

# ── VPC ──────────────────────────────────────────────────────────
module "vpc" {
  source             = "../../modules/vpc"
  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  kms_key_arn        = module.kms.key_arn
}

# ── IAM ──────────────────────────────────────────────────────────
module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  github_org   = var.github_org
}

# ── ECR ──────────────────────────────────────────────────────────
module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
  service_name = "app-service"
  kms_key_arn  = module.kms.key_arn
}

# ── EKS ──────────────────────────────────────────────────────────
module "eks" {
  source                    = "../../modules/eks"
  project_name              = var.project_name
  environment               = var.environment
  kubernetes_version        = var.kubernetes_version
  cluster_role_arn          = module.iam.eks_cluster_role_arn
  node_role_arn             = module.iam.eks_nodes_role_arn
  private_subnet_ids        = module.vpc.private_subnet_ids
  cluster_security_group_id = module.vpc.eks_cluster_sg_id
  kms_key_arn               = module.kms.key_arn
  node_instance_types       = var.node_instance_types
  node_desired_size         = var.node_desired_size
  node_min_size             = var.node_min_size
  node_max_size             = var.node_max_size
}
