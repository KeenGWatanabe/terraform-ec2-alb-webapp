output "application_http_url" {
  value = "http://${module.alb.dns_name}"
}

