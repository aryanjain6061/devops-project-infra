output "master_public_ip"   { value = aws_eip.master.public_ip }
output "master_private_ip"  { value = aws_instance.master.private_ip }
output "worker_private_ips" { value = aws_instance.worker[*].private_ip }
output "key_pair_name"      { value = aws_key_pair.k8s.key_name }
