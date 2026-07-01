output "github_actions_role_arn"   { value = aws_iam_role.github_actions.arn }
output "k8s_nodes_instance_profile" { value = aws_iam_instance_profile.k8s_nodes.name }
output "k8s_nodes_role_arn"        { value = aws_iam_role.k8s_nodes.arn }
