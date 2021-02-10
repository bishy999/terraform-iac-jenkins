output "VPC-ID-EU-WEST-1" {
  value = aws_vpc.vpc_master_ireland.id
}

output "VPC-ID-EU-WEST-2" {
  value = aws_vpc.vpc_master_london.id
}

output "PEERING-CONNECTION-ID" {
  value = aws_vpc_peering_connection.euwest1-euwest2.id
}

output "Jenkins-Main-Node-Public-IP" {
  value = aws_instance.jenkins-master-ireland.public_ip
}

output "Jenkins-Worker-Public-IPs" {
  value = {
    for instance in aws_instance.jenkins-worker-london :
    instance.id => instance.public_ip
  }
}

output "LB-DNS-NAME" {
  value = aws_lb.application-lb.dns_name
}

output "url" {
  value = aws_route53_record.jenkins.fqdn
}