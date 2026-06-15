output "cluster_name"     { value = aws_eks_cluster.main.name }
output "cluster_endpoint" { value = aws_eks_cluster.main.endpoint }
output "cluster_oidc_url" { value = aws_eks_cluster.main.identity[0].oidc[0].issuer }
