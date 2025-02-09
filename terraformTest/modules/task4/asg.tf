resource "aws_launch_template" "meitar_launch_tenplate" {
  name_prefix   = "meitar-launchTemplate-"
  image_id      = "ami-0e1bed4f06a3b463d"  # Replace with a dynamic lookup if needed
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.vm_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "meitar-vm"
    }
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
              )

}

resource "aws_autoscaling_group" "meitar_autoScalingGroup" {
  vpc_zone_identifier = var.subnet_id
  desired_capacity = var.min_size
  min_size = var.min_size
  max_size = var.max_size

  launch_template {
    id = aws_launch_template.meitar_launch_tenplate.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.meitar-target-group.arn]

  health_check_type         = "EC2"
  health_check_grace_period = 300
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "meitar-vm-autoScalingGroup"
    propagate_at_launch = true
  }
}
