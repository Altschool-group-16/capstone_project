# Network Infrastructure Deployment for Capstone Project

## Description

This project aims to deploy a cloud infrastructure for the Capstone Project using AWS (Amazon Web Services). The infrastructure includes the creation of a Virtual Private Cloud (VPC) with public and private subnets, NAT Gateways, Internet Gateway, and security groups for different components.

## Table of Contents

- [Network Infrastructure Deployment for Capstone Project](#network-infrastructure-deployment-for-capstone-project)
  - [Description](#description)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Infrastructure Components](#infrastructure-components)
  - [Usage](#usage)
  - [Contact](#contact)

## Requirements

To use and deploy this infrastructure, you need to have the following prerequisites:

- [Terraform](https://www.terraform.io/) installed on your machine.
- Appropriate AWS credentials configured on your system.
- Knowledge of AWS services and networking concepts.

## Infrastructure Components

This infrastructure will be deployed with the following components:

1. **VPC (Virtual Private Cloud)**: A custom VPC will be created with a specified CIDR block and default tenancy.

2. **Internet Gateway**: An Internet Gateway will be created and attached to the VPC to enable communication between the VPC and the internet.

3. **Public Subnets**: Two public subnets will be created in different Availability Zones (AZs) to ensure high availability. These subnets will have public IP addresses assigned to instances launched in them.

4. **NAT Gateways**: Two NAT Gateways will be created, one for each public subnet, to allow private instances in the private subnets to access the internet.

5. **Private Subnets (Application and Data)**: Two sets of private subnets will be created in different AZs. One set will be used for application instances, and the other set will be used for data instances. These subnets will not have public IP addresses assigned.

6. **Security Groups**: Different security groups will be created to control traffic between instances. The security groups will allow specific protocols and ports as required.

## Usage

1. Clone the repository and navigate to the project directory.
2. Make sure you have the required credentials and Terraform installed.
3. Customize the variables in the `variables.tf` file as per your requirements.
4. Run `terraform init` to initialize the Terraform project.
5. Run `terraform apply` to deploy the infrastructure.

## Contact

If you have any questions or need further assistance, please feel free to contact:

- Email: auomidejohnson@gmail.com
- GitHub: [Royalboe](https://github.com/Royalboe)
