# Network

## Description

This contains the code to create a new virtual private cloud on AWS

### Breakdown

This is a three tier network architecture. We have the VPC, it contains two availability zones, one public subnet in each of the AZs and two private subnets in each of the AZs. The public subnets will host the autoscaling groups for the web servers as well as the NAT gateway. It will also connect with the Internet Gateway. The private subnets will host the Database servers as well as the Application servers autoscaling groups.
We created redundancy by using two AZs. We also made the application highly available by using the autoscaling services that scales up and scales down the number of servers based on user's demand/traffic.
Security groups were created for the web servers, application servers and the loadbalancers.
We also have route tables and reserved IP addresses to attach to the NAT gateways.