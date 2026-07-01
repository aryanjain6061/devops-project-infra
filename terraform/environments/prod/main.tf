# ── KMS ───────────────────────────────────────────────────────
module "kms" {
  source       = "../../modules/kms"
  project_name = var.project_name
  environment  = var.environment
}

# ── VPC ───────────────────────────────────────────────────────
module "vpc" {
  source             = "../../modules/vpc"
  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  kms_key_arn        = module.kms.key_arn
}

# ── IAM ───────────────────────────────────────────────────────
module "iam" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  github_org   = var.github_org
}

# ── ECR ───────────────────────────────────────────────────────
module "ecr" {
  source       = "../../modules/ecr"
  project_name = var.project_name
  service_name = "app-service"
  kms_key_arn  = module.kms.key_arn
}

# ── Security Groups ───────────────────────────────────────────
module "sg" {
  source           = "../../modules/sg"
  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# ── EC2 Instances ─────────────────────────────────────────────
module "ec2" {
  source                = "../../modules/ec2"
  project_name          = var.project_name
  environment           = var.environment
  ami_id                = var.ami_id
  master_instance_type  = var.master_instance_type
  worker_instance_type  = var.worker_instance_type
  worker_count          = var.worker_count
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  private_subnet_ids    = module.vpc.private_subnet_ids
  master_sg_id          = module.sg.master_sg_id
  worker_sg_id          = module.sg.worker_sg_id
  kms_key_arn           = module.kms.key_arn
  instance_profile_name = module.iam.k8s_nodes_instance_profile
  ssh_public_key_path   = var.ssh_public_key_path
}
