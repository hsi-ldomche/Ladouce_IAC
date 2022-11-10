output "loadbalancer_dns"{
    description = "application load balancer dns"
    value = aws_lb.alb.dns_name
}

output "ec2_private_ip"{
    description = "ec2 instance private ip address"
    value = aws_instance.ec2_websrv.private_ip
}