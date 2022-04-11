provider "aws" {
  region = var.region_var
}

resource "aws_vpc" "devops106_terraform_emile_vpc_tf" {
  cidr_block = "10.205.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "devops106_terraform_emile_vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "devops106_terraform_emile_subnet_webserver_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.205.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "devops106_terraform_emile_subnet_webserver"
  }
}

resource "aws_internet_gateway" "devops106_terraform_emile_igw_tf" {
  vpc_id = local.vpc_id_var

  tags = {
    Name = "devops106_terraform_emile_igw"
  }
}

resource "aws_route_table" "devops106_terraform_emile_rt_public_tf" {
  vpc_id = local.vpc_id_var

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops106_terraform_emile_igw_tf.id
  }

  tags = {
    Name = "devops106_terraform_emile_rt_public"
  }
}

resource "aws_route_table_association" "devops106_terraform_emile_rt_assoc_public_webserver_tf" {
  subnet_id = aws_subnet.devops106_terraform_emile_subnet_webserver_tf.id
  route_table_id = aws_route_table.devops106_terraform_emile_rt_public_tf.id
}


resource "aws_network_acl" "devops106_terraform_emile_nacl_proxy_tf" {
  vpc_id = local.vpc_id_var

  ingress {
    rule_no    = 100
    from_port  = 22
    to_port    = 22
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 200
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 300
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }


  egress {
    rule_no    = 100
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"

  }

  egress {
    rule_no    = 200
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 10000
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }



   tags = {
    Name = "devops106_terraform_emile_nacl_public"
  }

  subnet_ids = [aws_subnet.devops106_terraform_emile_subnet_proxy_tf.id]
}

resource "aws_network_acl" "devops106_terraform_emile_nacl_public_tf" {
  vpc_id = local.vpc_id_var

  ingress {
    rule_no    = 100
    from_port  = 22
    to_port    = 22
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 200
    from_port  = 8080
    to_port    = 8080
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 300
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 100
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"

  }

  egress {
    rule_no    = 200
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 10000
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }



  subnet_ids = [
    aws_subnet.devops106_terraform_emile_subnet_web2_tf.id,
    aws_subnet.devops106_terraform_emile_subnet_webserver_tf.id
  ]

  tags = {
    Name = "devops106_terraform_emile_nacl_public"
  }
}

resource "aws_security_group" "devops106_terraform_emile_sg_webserver_tf" {
  name = "devops106_terraform_emile_sg_webserver"
  vpc_id = local.vpc_id_var

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }

  egress {
    from_port = 0
    protocol  = -1 # all the protocols are accepted
    to_port   = 0 # all ports are allowed
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops106_terraform_emile_sg_webserver"
  }

}



######################PROXY SERVER#####################################################

resource "aws_instance" "devops106_terraform_emile_proxy_tf" {
  ami = var.ubuntu_20_04_ami_id_var
  instance_type = var.instance_type_t2_micro_var
  key_name = "devops106_ethompson"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_emile_sg_proxy_tf.id]

  subnet_id = aws_subnet.devops106_terraform_emile_subnet_proxy_tf.id

  associate_public_ip_address = true

  user_data = data.template_file.proxy_init.rendered

  tags = {
    Name = "devops106_terraform_emile_proxy"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }

}

data "template_file" "proxy_init" {
  template = file("../init_scripts/proxy-install.sh")
/*
#  vars = {
#    "SERVER1" = aws_instance.devops106_terraform_emile_webserver_tf[0].private_ip
#    "SERVER2" = aws_instance.devops106_terraform_emile_webserver_tf[1].private_ip
#    "SERVER3" = aws_instance.devops106_terraform_emile_webserver_tf[2].private_ip
#
#  }
  */
}

#################################WEBSERVER INSTANCE#################################################################

resource "aws_instance" "devops106_terraform_emile_webserver_tf" {
  ami = var.docker_spartan_ami
  instance_type = var.instance_type_t2_micro_var
  key_name = "devops106_ethompson"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_emile_sg_webserver_tf.id]

  subnet_id = aws_subnet.devops106_terraform_emile_subnet_webserver_tf.id

  associate_public_ip_address = true

  count = 1
  user_data = data.template_file.app_init.rendered

  tags = {
    Name = "devops106_terraform_emile_webserver_${count.index}"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }
  /*
  provisioner "file" {
    source = "../init_scripts/docker-install.sh"
    destination = "/home/ubuntu/docker-install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /home/ubuntu/docker-install.sh"
    ]

  }
  */


#  provisioner "local-exec" {
#    command = "echo mongodb://${aws_instance.devops106_terraform_emile_mongodb_tf.public_ip}:27017 > ../database.config"
#  }
#
#  provisioner "file" {
#    source = "../database.config"
#    destination = "/home/ubuntu/database.config"
#  }
#
#  provisioner "file" {
#    source = "../init_scripts/proxy-install.sh"
#    destination = "/home/ubuntu/proxy-install.sh"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "bash /home/ubuntu/proxy-install.sh"
#
#    ]
#  }


}
data "template_file" "app_init" {
  template = file("../init_scripts/docker-install.sh")
}
##########################WEB SERVER LOAD##################
resource "aws_instance" "devops106_terraform_web2_tf" {
  ami                    = var.docker_spartan_ami
  instance_type          = var.instance_type_t2_micro_var
  key_name               = "devops106_ethompson"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_emile_sg_webserver_tf.id]

  subnet_id = aws_subnet.devops106_terraform_emile_subnet_web2_tf.id

  associate_public_ip_address = true

  count     = 1
  user_data = data.template_file.app_init.rendered

  tags = {
    Name = "devops106_terraform_emile_web2_${count.index}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key_file_path_var)

  }
}


#######################################MONGODB INSTANCE###########################################################
resource "aws_instance" "devops106_terraform_emile_mongodb_tf" {
  ami                    = var.ubuntu_20_04_ami_id_var
  instance_type          = var.instance_type_t2_micro_var
  key_name               = var.public_key_name_var
  vpc_security_group_ids = [aws_security_group.devops106_terraform_emile_sg_mongodb_tf.id]

  subnet_id = aws_subnet.devops106_terraform_emile_subnet_mongodb_tf.id

  associate_public_ip_address = true

  user_data = data.template_file.db_init.rendered

  tags                        = {
    Name = "devops106_terraform_emile_mongodb"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key_file_path_var)
  }

#  provisioner "file" {
#    source      = "../init_scripts/mongodb-install.sh"
#    destination = "/home/ubuntu/mongodb-install.sh"
#  }
#
#  provisioner "remote-exec" {
#
#    inline = [
#      "bash /home/ubuntu/mongodb-install.sh"
#    ]
#  }
}
data "template_file" "db_init" {
  template = file("../init_scripts/mongodb-install.sh")
}

resource "aws_security_group" "devops106_terraform_emile_sg_proxy_tf" {
  name = "devops106_terraform_emile_sg_proxy"
  vpc_id = local.vpc_id_var

  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = -1
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "devops106_terraform_emile_sg_proxy"
  }
}

resource "aws_security_group" "devops106_terraform_emile_sg_mongodb_tf" {
  name = "devops106_terraform_emile_sg_mongodb"
  vpc_id = local.vpc_id_var

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 27017
    to_port   = 27017
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol  = -1 # all the protocols are accepted
    to_port   = 0 # all ports are allowed
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops106_terraform_emile_sg_mongodb"
  }

}
resource "aws_subnet" "devops106_terraform_emile_subnet_web2_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.205.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "devops106_terraform_emile_subnet_web2"
  }
}

resource "aws_subnet" "devops106_terraform_emile_subnet_proxy_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.205.3.0/24"

  tags = {
    Name = "devops106_terraform_emile_subnet_proxy"
  }
}

resource "aws_subnet" "devops106_terraform_emile_subnet_mongodb_tf" {
  vpc_id = local.vpc_id_var
  cidr_block = "10.205.2.0/24"

  tags = {
    Name = "devops106_terraform_emile_subnet_mongodb"
  }
}



resource "aws_route_table_association" "devops106_terraform_emile_rt_assoc_public_proxy_tf" {
  subnet_id = aws_subnet.devops106_terraform_emile_subnet_proxy_tf.id
  route_table_id = aws_route_table.devops106_terraform_emile_rt_public_tf.id
}

resource "aws_route_table_association" "devops106_terraform_emile_rt_assoc_public_mongodb_tf" {
  subnet_id = aws_subnet.devops106_terraform_emile_subnet_mongodb_tf.id
  route_table_id = aws_route_table.devops106_terraform_emile_rt_public_tf.id
}

resource "aws_route_table_association" "devops106_terraform_emile_rt_assoc_public_web2_tf" {
  subnet_id = aws_subnet.devops106_terraform_emile_subnet_web2_tf.id
  route_table_id = aws_route_table.devops106_terraform_emile_rt_public_tf.id
}

resource "aws_network_acl" "devops106_terraform_emile_nacl_mongodb_public_tf" {
  vpc_id = local.vpc_id_var

  ingress {
    rule_no    = 100
    from_port  = 22
    to_port    = 22
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 200
    from_port  = 27017
    to_port    = 27017
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  ingress {
    rule_no    = 300
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }


  egress {
    rule_no    = 100
    from_port  = 80
    to_port    = 80
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"

  }

  egress {
    rule_no    = 200
    from_port  = 443
    to_port    = 443
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }

  egress {
    rule_no    = 10000
    from_port  = 1024
    to_port    = 65535
    cidr_block = "0.0.0.0/0"
    protocol   = "tcp"
    action     = "allow"
  }


  subnet_ids = [aws_subnet.devops106_terraform_emile_subnet_mongodb_tf.id]

  tags = {
    Name = "devops106_terraform_emile_nacl_mongodb_public"
  }
}
resource "aws_route53_zone" "devops106_terraform_emile_dns_zone" {
  name = "emile.devops106"

  vpc {
    vpc_id = local.vpc_id_var
  }
}
resource "aws_route53_record" "devops106_terraform_emile_dns_db_tf" {
  name    = "db_emile"
  type    = "A"
  zone_id = aws_route53_zone.devops106_terraform_emile_dns_zone.zone_id
  ttl = "30"
  records = [aws_instance.devops106_terraform_emile_mongodb_tf.public_ip]
}
##########################Load balancer and target groups###############################################
resource "aws_lb" "devops106_terraform_emile_lb_tf" { #load balancer, cant use underscores
  name = "devops106terraformemile-lb"
  internal = false
  load_balancer_type = "application"
  subnets = [
    aws_subnet.devops106_terraform_emile_subnet_webserver_tf.id,
    aws_subnet.devops106_terraform_emile_subnet_web2_tf.id
  ]
  security_groups = [aws_security_group.devops106_terraform_emile_sg_webserver_tf.id]

  tags = {
    Name = "devops106_terraform_emile_lb"
  }
}

resource "aws_lb_target_group" "devops106_terraform_emile_tg_tf" {
  name = "devops106terraformemile-tg"
  port = 8080
  target_type = "instance"
  protocol = "HTTP"
  vpc_id = local.vpc_id_var
}

resource "aws_alb_target_group_attachment" "devops106_terraform_emile_tg_attach_tf" {
  target_group_arn = aws_lb_target_group.devops106_terraform_emile_tg_tf.arn
  count = length(aws_instance.devops106_terraform_emile_webserver_tf)
  target_id = aws_instance.devops106_terraform_emile_webserver_tf[count.index].id
}

resource "aws_alb_target_group_attachment" "devops106_terraform_emile_tg_2_attach_tf" {
  target_group_arn = aws_lb_target_group.devops106_terraform_emile_tg_tf.arn
  count = length(aws_instance.devops106_terraform_web2_tf)
  target_id = aws_instance.devops106_terraform_web2_tf[count.index].id
}


resource "aws_lb_listener" "devops_lb_tf" {
  load_balancer_arn = aws_lb.devops106_terraform_emile_lb_tf.arn
  port = 8080
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.devops106_terraform_emile_tg_tf.arn
  }
}

resource "aws_route53_record" "devops106_terraform_emile_dns_proxy_tf" {
  name    = "proxy_emile"
  type    = "A"
  zone_id = aws_route53_zone.devops106_terraform_emile_dns_zone.zone_id
  ttl = "30"
  records = [aws_instance.devops106_terraform_emile_proxy_tf.public_ip]
}

resource "aws_route53_record" "devops106_terraform_emile_dns_webservers_tf" {
  name    = "app"
  type    = "A"
  zone_id = aws_route53_zone.devops106_terraform_emile_dns_zone.zone_id
  ttl = "30"
  records = aws_instance.devops106_terraform_emile_webserver_tf[*].private_ip
}
