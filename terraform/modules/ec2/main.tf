# ── SSH Key Pair ──────────────────────────────────────────────
resource "aws_key_pair" "k8s" {
  key_name   = "${var.project_name}-${var.environment}-k8s-key"
  public_key = file(var.ssh_public_key_path)

  tags = {
    Name = "${var.project_name}-${var.environment}-k8s-key"
  }
}

# ── Elastic IP for Master (stays fixed across restarts) ───────
resource "aws_eip" "master" {
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-${var.environment}-master-eip"
  }
}

# ── Master Node ───────────────────────────────────────────────
resource "aws_instance" "master" {
  ami                    = var.ami_id
  instance_type          = var.master_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.master_sg_id]
  key_name               = aws_key_pair.k8s.key_name
  iam_instance_profile   = var.instance_profile_name

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    kms_key_id            = var.kms_key_arn
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    hostnamectl set-hostname k8s-master
    echo "k8s-master" > /etc/hostname
  EOF
  )

  tags = {
    Name = "${var.project_name}-${var.environment}-k8s-master"
    Role = "master"
  }
}

# ── Attach Elastic IP to Master ───────────────────────────────
resource "aws_eip_association" "master" {
  instance_id   = aws_instance.master.id
  allocation_id = aws_eip.master.id
}

# ── Worker Nodes ──────────────────────────────────────────────
resource "aws_instance" "worker" {
  count                  = var.worker_count
  ami                    = var.ami_id
  instance_type          = var.worker_instance_type
  subnet_id              = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]
  vpc_security_group_ids = [var.worker_sg_id]
  key_name               = aws_key_pair.k8s.key_name
  iam_instance_profile   = var.instance_profile_name

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    kms_key_id            = var.kms_key_arn
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -e
    hostnamectl set-hostname k8s-worker-${count.index + 1}
    echo "k8s-worker-${count.index + 1}" > /etc/hostname
  EOF
  )

  tags = {
    Name = "${var.project_name}-${var.environment}-k8s-worker-${count.index + 1}"
    Role = "worker"
  }
}
