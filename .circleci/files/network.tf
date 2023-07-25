# Using data source retrieve available availability zones
data "aws_availability_zones" "zones" {
  state = "available"
}

# Create the VPC for the project
resource "aws_vpc" "Capstone_Net" {
  cidr_block       = var.main_vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = var.proj-tag
}

# Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id =  aws_vpc.Capstone_Net.id 
  tags = var.proj-tag
}

# Create two EIPs for the two NAT Gateways
resource "aws_eip" "eip_1" {
  domain = "vpc"
  tags = var.proj-tag
}

resource "aws_eip" "eip_2" {
  domain = "vpc"
  tags = var.proj-tag
}

# Create two NAT Gateways
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.publicsubnet_1.id
  vpc_id        = aws_vpc.capstone_Net.id
  tags = var.proj-tag
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.eip_2.id
  subnet_id = aws_subnet.publicsubnet_2.id
  vpc_id = aws_vpc.capstone_Net.id
  tags = var.proj-tag
}

# Create two Public Subnets in the two AZs.
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


# Route table for Public Subnets; Route to Internet Gateway
resource "aws_route_table" "PublicRT" {
  vpc_id =  aws_vpc.Altschool_Net.id
  route {
    cidr_block = var.destination_cidr_block
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = var.proj-tag
}

# Route table Association with Public Subnets
resource "aws_route_table_association" "PublicRTassociation_1" {
  subnet_id = aws_subnet.publicsubnet_1.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PublicRTassociation_2" {
    subnet_id = aws_subnet.publicsubnet_2.id
    route_table_id = aws_route_table.PublicRT.id
}

# Create the two private app subnets

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

# Private route tables for app subnets: Routes to NAT Gateways
resource "aws_route_table" "PrivRT_1" {
  vpc_id =  aws_vpc.capstone_Net.id
  route {
    cidr_block = var.destination_cidr_block
    gateway_id = aws_nat_gateway.nat_1.id
  }
  tags = var.proj-tag
}

resource "aws_route_table" "PrivRT_2" {
  vpc_id =  aws_vpc.capstone_Net.id
  route {
    cidr_block = var.destination_cidr_block
    gateway_id = aws_nat_gateway.nat_2.id
  }
  tags = var.proj-tag
}
# Route table Association with Private app subnet 1
resource "aws_route_table_association" "PrivRTassociation_1" {
  subnet_id = aws_subnet.private_app_subnet_1.id
  route_table_id = aws_route_table.PrivRT_1.id
}

# Route table Association with Private app subnet 2
resource "aws_route_table_association" "PrivRTassociation_2" {
  subnet_id = aws_subnet.private_app_subnet_2.id
  route_table_id = aws_route_table.PrivRT_2.id
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


# Create a Security Group for the web servers instance
resource "aws_security_group" "web_server_SG" {
  name        = "Web_Server_SG"
  description = "Allow SSH, Prometheus, and Loadbalancer traffic"
  vpc_id      = aws_vpc.Capstone_Net.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Load Balancer"
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9000
    to_port     = 9000
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

# Create a Security Group for the Application Servers
resource "aws_security_group" "app_server_SG" {
  name        = "App_Server_SG"
  description = "Allow SSH, Prometheus, and Loadbalancer traffic"
  vpc_id      = aws_vpc.Capstone_Net.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Load Balancer"
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9000
    to_port     = 9000
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


# Create a Security Group for the application load balancer
resource "aws_security_group" "Application_load_balancer_SG" {
  name        = "My_App_LB_SG"
  description = "Allow frontend traffic"
  vpc_id      = aws_vpc.Capstone_Net.id

  ingress {
    description = "Frontend traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic to the application servers"
    from_port = 3030
    to_port   = 3030
    protocol  = "tcp"
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

# Create a Security Group for the web servers load balancer
resource "aws_security_group" "Application_load_balancer_SG" {
  name        = "My_App_LB_SG"
  description = "Allow frontend traffic"
  vpc_id      = aws_vpc.Capstone_Net.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic to the web servers"
    from_port = 3030
    to_port   = 3030
    protocol  = "tcp"
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