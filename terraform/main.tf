provider "aws" {
  region = "eu-west-1"

}

resource "aws_vpc" "devops106_terraform_emile_vpc_tf" {
  cidr_block = "10.205.0.0/16"

  tags = {
    Name = "devops106_terraform_emile_vpc"
  }
}

resource "aws_subnet" "devops106_terraform_emile_subnet_webserver_tf" {
  vpc_id = aws_vpc.devops106_terraform_emile_vpc_tf.id
  cidr_block = "10.205.1.0/24"

  tags = {
    Name = "devops106_terraform_emile_subnet_webserver"
  }
}

resource "aws_internet_gateway" "devops106_terraform_emile_igw_tf" {
  vpc_id = aws_vpc.devops106_terraform_emile_vpc_tf.id

  tags = {
    Name = "devops106_terraform_emile_igw"
  }
}

resource "aws_route_table" "devops106_terraform_emile_rt_public_tf" {
  vpc_id = aws_vpc.devops106_terraform_emile_vpc_tf.id

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

resource "aws_network_acl" "devops106_terraform_emile_nacl_public_tf" {
  vpc_id = aws_vpc.devops106_terraform_emile_vpc_tf.id

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


  subnet_ids = [aws_subnet.devops106_terraform_emile_subnet_webserver_tf.id]

  tags = {
    Name = "devops106_terraform_emile_nacl_public"
  }
}

resource "aws_security_group" "devops106_terraform_emile_sg_webserver_tf" {
  name = "devops106_terraform_emile_sg_webserver"
  vpc_id = aws_vpc.devops106_terraform_emile_vpc_tf.id

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


resource "aws_instance" "devops106_terraform_emile_webserver_tf" {
  ami = "ami-08ca3fed11864d6bb"
  instance_type = "t2.micro"
  key_name = "devops106_ethompson"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_emile_sg_webserver_tf.id]

  subnet_id = aws_subnet.devops106_terraform_emile_subnet_webserver_tf.id

  associate_public_ip_address = true
  tags = {
    Name = "devops106_terraform_emile_webserver"
  }
}
#######################################MONGODB INSTANCE###########################################################
resource "aws_instance" "devops106_terraform_emile_mongodb_tf" {
  ami = "ami-08ca3fed11864d6bb"
  instance_type = "t2.micro"
  key_name = "devops106_ethompson"
  vpc_security_group_ids = [aws_security_group.devops106_terraform_emile_sg_mongodb_tf.id]

  subnet_id = aws_subnet.devops106_terraform_emile_subnet_mongodb_tf.id

  associate_public_ip_address = true
  tags = {
    Name = "devops106_terraform_emile_mongodb"
  }
}

resource "aws_security_group" "devops106_terraform_emile_sg_mongodb_tf" {
  name = "devops106_terraform_emile_sg_mongodb"
  vpc_id = aws_vpc.devops106_terraform_emile_vpc_tf.id

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
resource "aws_subnet" "devops106_terraform_emile_subnet_mongodb_tf" {
  vpc_id = aws_vpc.devops106_terraform_emile_vpc_tf.id
  cidr_block = "10.205.2.0/24"

  tags = {
    Name = "devops106_terraform_emile_subnet_mongodb"
  }
}


resource "aws_route_table_association" "devops106_terraform_emile_rt_assoc_public_mongodb_tf" {
  subnet_id = aws_subnet.devops106_terraform_emile_subnet_mongodb_tf.id
  route_table_id = aws_route_table.devops106_terraform_emile_rt_public_tf.id
}

resource "aws_network_acl" "devops106_terraform_emile_nacl_mongodb_public_tf" {
  vpc_id = aws_vpc.devops106_terraform_emile_vpc_tf.id

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
