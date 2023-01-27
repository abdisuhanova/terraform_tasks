
//INTANCE CREATION
resource "aws_launch_template" "template" { 
  instance_type =  local.instance_type
  image_id = "ami-0ab0629dba5ae551d"
  key_name = local.rsa

   tags = { 
    Name = "template" 
  } 

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [local.sg_id]
  }
 
  user_data = base64encode("#!/bin/bash \nsudo su \napt install apache2 -y \nsystemctl start apache2 -y \nsystemctl enable apache2 -y \necho \"Hello, World!\" > /var/www/html/index.html")

  depends_on = [
    aws_key_pair.demo_key
  ]
}


//AUTOSCALING GROUP

resource "aws_autoscaling_group" "bar" {
  desired_capacity   = 3
  max_size           = 4
  min_size           = 3
  target_group_arns = [local.target_group_id]
  vpc_zone_identifier = local.sub_ids

  launch_template {
    id      = local.launch_template_id
  }
  depends_on = [
    aws_launch_template.template,
    aws_lb_target_group.main
   ]
}


//LOAD BALANCER
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.sg_id]
  subnets            = local.sub_ids
  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}