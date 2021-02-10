###################
# VPC
###################
#Create VPC in eu-west-1
resource "aws_vpc" "vpc_master_ireland" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-jenkins"
  }

}


#Create VPC in eu-west-2
resource "aws_vpc" "vpc_master_london" {
  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "worker-jenkins"
  }

}


###################
# IGW
###################
#Create IGW in in eu-west-1
resource "aws_internet_gateway" "igw-ireland" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master_ireland.id
  tags = {
    Name = "master-jenkins"
  }
}


#Create IGW in in eu-west-2
resource "aws_internet_gateway" "igw-london" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_master_london.id
  tags = {
    Name = "worker-jenkins"
  }
}


###################
# Subnets
###################

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}


#Create subnet # 1 in eu-west-1
resource "aws_subnet" "subnet_1_ireland" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master_ireland.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "master-jenkins"
  }
}


#Create subnet #2  in eu-west-1
resource "aws_subnet" "subnet_2_ireland" {
  provider          = aws.region-master
  vpc_id            = aws_vpc.vpc_master_ireland.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "master-jenkins"
  }
}

#Create subnet in eu-west-2
resource "aws_subnet" "subnet_1_london" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc_master_london.id
  cidr_block = "192.168.1.0/24"
  tags = {
    Name = "worker-jenkins"
  }

}

###################
# VPC Peering
###################

#Initiate Peering connection request from eu-west-1
resource "aws_vpc_peering_connection" "euwest1-euwest2" {
  provider    = aws.region-master
  peer_vpc_id = aws_vpc.vpc_master_london.id
  vpc_id      = aws_vpc.vpc_master_ireland.id
  peer_region = var.region-worker

}

#Accept VPC peering request in eu-west-2 from eu-west-1
resource "aws_vpc_peering_connection_accepter" "accept_peering" {
  provider                  = aws.region-worker
  vpc_peering_connection_id = aws_vpc_peering_connection.euwest1-euwest2.id
  auto_accept               = true
}


##############
# Route Table
#############

#Create route table in eu-west-1
resource "aws_route_table" "internet_route_ireland" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master_ireland.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-ireland.id
  }
  route {
    cidr_block                = "192.168.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.euwest1-euwest2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "master-jenkins"
  }
}


#Overwrite default route table of VPC(Master) with our route table entries
resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  provider       = aws.region-master
  vpc_id         = aws_vpc.vpc_master_ireland.id
  route_table_id = aws_route_table.internet_route_ireland.id
}


#Create route table in eu-west-2
resource "aws_route_table" "internet_route_london" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_master_london.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-london.id
  }
  route {
    cidr_block                = "10.0.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.euwest1-euwest2.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "worker-jenkins"
  }
}

#Overwrite default route table of VPC(Worker) with our route table entries
resource "aws_main_route_table_association" "set-worker-default-rt-assoc" {
  provider       = aws.region-worker
  vpc_id         = aws_vpc.vpc_master_london.id
  route_table_id = aws_route_table.internet_route_london.id
}