# ── Master Node Security Group ────────────────────────────────
resource "aws_security_group" "master" {
  name        = "${var.project_name}-${var.environment}-k8s-master-sg"
  description = "Security group for Kubernetes master node"
  vpc_id      = var.vpc_id

  # SSH from your IP only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    description = "SSH from admin only"
  }

  # Kubernetes API server
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "K8s API server"
  }

  # etcd
  ingress {
    from_port = 2379
    to_port   = 2380
    protocol  = "tcp"
    self      = true
    description = "etcd server client API"
  }

  # kubelet API
  ingress {
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.worker.id]
    description     = "kubelet API from workers"
  }

  # kube-scheduler
  ingress {
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
    self        = true
    description = "kube-scheduler"
  }

  # kube-controller-manager
  ingress {
    from_port   = 10252
    to_port     = 10252
    protocol    = "tcp"
    self        = true
    description = "kube-controller-manager"
  }

  # Allow all from workers (pod networking)
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.worker.id]
    description     = "all traffic from worker nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-k8s-master-sg"
  }
}

# ── Worker Node Security Group ────────────────────────────────
resource "aws_security_group" "worker" {
  name        = "${var.project_name}-${var.environment}-k8s-worker-sg"
  description = "Security group for Kubernetes worker nodes"
  vpc_id      = var.vpc_id

  # SSH from your IP only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    description = "SSH from admin only"
  }

  # kubelet API from master
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    self        = true
    description = "kubelet API"
  }

  # NodePort services
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NodePort services"
  }

  # Pod to pod traffic (Calico CNI)
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
    description = "pod to pod all traffic"
  }

  # All traffic from master
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.master.id]
    description     = "all traffic from master node"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-k8s-worker-sg"
  }
}
