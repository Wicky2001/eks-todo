data "aws_availability_zones" "available"{
    state = "available"
}


locals {
  public_subnets = {
    "az1" = {
      cidr = "10.0.1.0/24"
      az   = data.aws_availability_zones.available.names[0]
    }
    "az2" = {
      cidr = "10.0.2.0/24"
      az   = data.aws_availability_zones.available.names[1]
    }
  }

  private_subnets = {
    "az1" = {
      cidr = "10.0.3.0/24"
      az   = data.aws_availability_zones.available.names[0]
    }
    "az2" = {
      cidr = "10.0.4.0/24"
      az   = data.aws_availability_zones.available.names[1]
    }
  }
}





resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
    Project = var.project_name
    Environment = var.environment
  }
}


resource "aws_subnet" "public" {
 for_each = local.public_subnets

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-${var.environment}-public-${each.key}"
    Project = var.project_name
    Environment = var.environment
    Tier = "public"
  }
}


resource "aws_subnet" "private" {
 for_each = local.private_subnets

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-${var.environment}-private-${each.key}"
    Project = var.project_name
    Environment = var.environment
    Tier = "private"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
    Project = var.project_name
    Environment = var.environment
  }
}

//elastic ip for each nat gateway
resource "aws_eip" "nat" {
  for_each = local.public_subnets  
  domain = "vpc"
  tags = {
    Name = "${var.project_name}-${var.environment}-nat-eip-${each.key}"
    Project = var.project_name
    Environment = var.environment
  }
}

// nat gateway in each public subnet
resource "aws_nat_gateway" "main" {
  for_each = local.public_subnets  
  allocation_id = aws_eip.nat[each.key].id
  subnet_id = aws_subnet.public[each.key].id
  tags = {
    Name = "${var.project_name}-${var.environment}-nat-gateway"
    Project = var.project_name
    Environment = var.environment
  }
}


//public route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
    Project = var.project_name
    Environment = var.environment
    Tier = "public"
  }
}

//public route table associations
resource "aws_route_table_association" "public" {
  for_each = local.public_subnets  
  subnet_id = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}


/*
  Private Route Tables:
  We create a separate route table for each private subnet.
  This allows us to associate each private subnet with its 
  corresponding NAT Gateway in the same Availability Zone.

  i.e. route table in private subnet1 will route traffc to nat gateway in az1
       route tale in private subnet2 will route traffic to nat gatway in az2

*/

resource "aws_route_table" "private" {
  for_each = local.private_subnets  
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[each.key].id
  }
  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-${each.key}"
    Project = var.project_name
    Environment = var.environment
    Tier = "private"
  }
}

//private route table associations
resource "aws_route_table_association" "private" {
  for_each = local.private_subnets  
  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}