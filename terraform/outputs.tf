output "webserver_ip_addresses_outpout" {
  value = aws_instance.devops106_terraform_emile_webserver_tf[*].public_ip # the * means i want all the resources
}

output "mongodb_ip_address" {
  value = aws_instance.devops106_terraform_emile_mongodb_tf.public_ip
}

output "proxy_server_ip_address" {
  value = aws_instance.devops106_terraform_emile_proxy_tf.public_ip
}