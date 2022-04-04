output "webserver_ip_addresses_outpout" {
  value = aws_instance.devops106_terraform_emile_webserver_tf[*].public_ip # the * means i want all the resources
}