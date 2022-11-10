resource "aws_instance" "ec2_websrv" {
  ami                    = var.ami
  subnet_id              = var.private_subnet
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name
  ebs_optimized          = "false"
  disable_api_termination = "true"
  source_dest_check      = "false"
  user_data              = data.template_file.user_data.rendered
  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = "true"
    encrypted             = "true"
    volume_size           = var.ec2_volume
  }
  tags = {
    "Name" = "${var.tags}"
  }

}


resource "null_resource" "copyssl" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("test-insights-key")
      host        =  aws_instance.ec2_websrv.private_ip
    }
  provisioner "file" {
    source      = "${var.ssl_cert}.zip"
    destination = "/home/ec2-user/${var.ssl_cert}.zip"
  }
  depends_on  = [aws_instance.ec2_websrv]

  }

data "template_file" "user_data" {
  template = file("user_data.tpl")
  vars = {
    ssl_certificate = "${var.ssl_cert}"
    agent_url       = "${var.agent_url}"
    agent_token     = "${var.agent_token}"
    agent_pool      = "${var.agent_pool}"
    agent_hostname  = "${var.agent_hostname}"
  }
}

output "ec2_ip" {
  value       = aws_instance.ec2_websrv.private_ip
  description = "ec2-private-ip"
  depends_on  = [aws_instance.ec2_websrv]
}

