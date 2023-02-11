data "aws_ami" "ubuntu" {
    owners = ["099720109477"] #Canonical
    most_recent = true 
    filter {
      name   = "name"
      values = ["ubuntu-minimal/images/hvm-ssd/ubuntu*"]
    }
    filter {
      name   = "root-device-type"
      values = ["ebs"]
    }
}


data "aws_ami_ids" "ubuntu" {
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_security_group" "instances_sg" {
name   = "SSH"
vpc_id = var.vpc_id

ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = var.ssh_access_cidr_blocks
}

ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  security_groups = [aws_security_group.lb_sg.id]
  #cidr_blocks = [data.aws_vpc.selected.cidr_block]
}


egress {
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]  
  }
}


resource "tls_private_key" "webservers" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "webservers-key"
  public_key = tls_private_key.webservers.public_key_openssh
}


resource "aws_launch_template" "asg_template" {
  name          = "playq"
  image_id                  = data.aws_ami.ubuntu.id
  instance_type             = "t2.micro"

  vpc_security_group_ids    = [aws_security_group.instances_sg.id]

  key_name                  = aws_key_pair.generated_key.key_name

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "PlayQ-2019"
      Type = "webserver"
    }
  }

  user_data = "${filebase64("./user_data.sh")}"
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "asg_policy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_group" "asg" {
  name = "playQ-asg"
  #availability_zones = ["us-east-1a","us-east-1b","us-east-1c"]
  availability_zones =  data.aws_availability_zones.available.names
  max_size           = 3
  min_size           = 2

  launch_template {
    id      = aws_launch_template.asg_template.id
    version = "$Latest"
  }
}

resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "terraform-test-foobar5"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_policy.arn]
}

