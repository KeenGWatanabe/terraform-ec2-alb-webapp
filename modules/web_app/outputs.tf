output "webapp_public_ips" {
  value = aws_instance.webapp.public_ip
}

output "target_group_arn" {
  value = aws_lb_target_group.webapp.arn
}
