data "aws_availability_zones" "zones" {
  state = "available"
}

# Create the VPC
resource "aws_vpc" "Capstone_Net" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = var.proj-tag
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id =  aws_vpc.Altschool_Net.id 
  tags = var.proj-tag
}


# Create Public Subnets.
resource "aws_subnet" "publicsubnet_1" {
  vpc_id =  aws_vpc.Altschool_Net.id
  cidr_block = "${var.public_subnets[0]}"
  map_public_ip_on_launch = true
 availability_zone       = data.aws_availability_zones.zones.names[0]
#   availability_zone = var.availability_zones[0]
  tags = var.proj-tag
}

resource "aws_subnet" "publicsubnet_2" {
  vpc_id =  aws_vpc.Altschool_Net.id
  cidr_block = "${var.public_subnets[1]}"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.zones.names[1]
#   availability_zone = var.availability_zones[1]
  tags = var.proj-tag
}

resource "aws_subnet" "publicsubnet_3" {
  vpc_id =  aws_vpc.Altschool_Net.id
  cidr_block = "${var.public_subnets[2]}"
  map_public_ip_on_launch = true
  # availability_zone       = data.aws_availability_zones.zones.names[2]
  availability_zone = var.availability_zones[2]
  tags = var.proj-tag
}

# Route table for Public Subnet's
resource "aws_route_table" "PublicRT" {
  vpc_id =  aws_vpc.Altschool_Net.id
  route {
    cidr_block = var.destination_cidr_block
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = var.proj-tag
}

# Route table Association with Public Subnet's
resource "aws_route_table_association" "PublicRTassociation_1" {
  subnet_id = aws_subnet.publicsubnet_1.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PublicRTassociation_2" {
    subnet_id = aws_subnet.publicsubnet_2.id
    route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PublicRTassociation_3" {
    subnet_id = aws_subnet.publicsubnet_3.id
    route_table_id = aws_route_table.PublicRT.id
}

# Create the private app subnets

resource "aws_subnet" "private_app_subnet_1" {
    vpc_id =  aws_vpc.Capstone_Net.id
    cidr_block = "${var.private_app_subnets[0]}"
    map_public_ip_on_launch = false
    availability_zone       = data.aws_availability_zones.zones.names[0]
}

resource "aws_subnet" "private_app_subnet_2" {
    vpc_id =  aws_vpc.Capstone_Net.id
    cidr_block = "${var.private_app_subnets[1]}"
    map_public_ip_on_launch = false
    availability_zone       = data.aws_availability_zones.zones.names[1]
}

# Create the private data subnets

resource "aws_subnet" "private_data_subnet_1" {
    vpc_id =  aws_vpc.Capstone_Net.id
    cidr_block = "${var.private_data_subnets[0]}"
    map_public_ip_on_launch = false
    availability_zone       = data.aws_availability_zones.zones.names[0]
}

resource "aws_subnet" "private_data_subnet_2" {
    vpc_id =  aws_vpc.Capstone_Net.id
    cidr_block = "${var.private_data_subnets[1]}"
    map_public_ip_on_launch = false
    availability_zone       = data.aws_availability_zones.zones.names[1]
}


# Create a Security Group for the EC2 instance
resource "aws_security_group" "web_server_SG" {
  name        = "Altschool_SG"
  description = "Allow SSH HTPPS, and, HTTP traffic"
  vpc_id      = aws_vpc.Altschool_Net.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.proj-tag
}

# Create a Security Group for the load balancer
resource "aws_security_group" "load_balancer_SG" {
  name        = "My_LB_SG"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.Altschool_Net.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.proj-tag
}