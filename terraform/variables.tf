variable "private_key_file_path_var" {
  default = "/home/vagrant/.ssh/devops106_ethompson.pem"
}

variable "ubuntu_20_04_ami_id_var" {
  default = "ami-08ca3fed11864d6bb"
}

variable "docker_spartan_ami" {
  default = "ami-0a6936474da4942f9"
}

variable "instance_type_t2_micro_var" {
  default = "t2.micro"
}

variable "public_key_name_var" {
  default = "devops106_ethompson"
}

variable "region_var" {
  default = "eu-west-1"
}

locals {
  vpc_id_var = aws_vpc.devops106_terraform_emile_vpc_tf.id
}

locals {
  vars = {
    public_ip_address = aws_instance.devops106_terraform_emile_webserver_tf[*]
  }
}


