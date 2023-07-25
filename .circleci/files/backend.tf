# Resources
resource "aws_security_group" "InstanceSecurityGroup" {
  name        = "UdaPeople-backend"
  description = "Allow port 22, port 9100 and port 3030."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

}
resource "aws_instance" "EC2Instance" {
  instance_type = "t2.micro"
  security_groups = [aws_security_group.InstanceSecurityGroup.name]
  key_name      = "udapeople"
  ami           = "ami-068663a3c619dd892" # Replace with the appropriate AMI ID for your region and requirements

  tags = {
    Name = "backend-server"
  }
}


# Create a .pem file
# RSA key of size 2048 bits
# resource "tls_private_key" "new-key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "local_sensitive_file" "private_key" {
#   filename          = "backend-key.pem"
#   content = tls_private_key.new-key.private_key_pem
#   file_permission   = "0700"
# }


# # Create a Key Pair
# resource "aws_key_pair" "devkey" {
#   key_name   = "backend-key"
#   public_key = tls_private_key.new-key.public_key_openssh
# }