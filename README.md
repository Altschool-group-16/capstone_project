# Automating The Deployment Of An Empolyee Management Application

## Description

In this project, we attempt to prove our understanding of using the following tools and platforms:

- Ansible for Configuration Managemt
- Terraform and cloud formation for Infrastructure as Code
- AWS cloud platform
- Grafana and Prometheus for monitoring, logging and data visualization
- Blue Green Deployment strategy

We used a serverless frontend by storing our frontend files in an S3 bucket and exposing it using cloudfront.

![Diagram of CI/CD Pipeline we will be building.](./application-pipeline.png)

### Steps

* Firstly, we created a free account on CircleCI and linked it to the GitHub organisation.
* We created a project linked to our project repository
* Then we created the config.yml file inside the .circleci folder.
* This file serves as a configuration file for CircleCI and it contains our jobs and workflow.
* We have three major phases in our project, these are: Build Phase, Infrastructure Phase, and Deployment Phase.
* In the build phase, we compiled/linted the source code to check for syntax errors or unintentional typos in code.
* We have a different job for frontend and backend for the Build Phase.
* After successfully compiling and linting the project, we moved to infrastructure deployment.
* We created a key-pair on the aws platform for the soon to be provisioned EC2 instances
* We created a postgres database using AWS RDS. We made this database available to any ec2 instance within our default VPC so that the provisioned EC2 will be able to communicate with it.
* We created an IAM user with programmatic access to be used by the CircleCi for the provisioning and management of our resources.
* Since the deployment strategy is blue green deployment strategy and we plan on using cloudfront to deliver our platform to users, we needed to manually create the first stack
* We also made our frontend serverless.
* We manually created the initial S3 bucket.
* We then manually ran the cloudformation script to spin up cloudfront resource and points it to the s3 bucket created.
* We added the private key of the key pair we created to the SSH environment of CircleCI and copied the associated fingerprint generated. This will give the deployment jobs access to the created EC2 instances in the deployment phase.
* We added the environment variables for the project in the project settings on CircleCI
* We then created a job to deploy the fronend and backend infrastructure on AWS
* After that we created another job to extract the IP address of the backend infrastructures
* After extracting that, we created a new job to configure the infrastrutures already created.
* We ran migrations and deployed the frontend and backend codes.
* After this we ran the smoke test job.
* Once this is successful, the cloudfront url points to the new bucket that was created for the frontend.
* And this completes our blue-green deployment.
* At everypoint in the continuous deployment cycle, once a job fails, the environment created also gets destroyed and we get an alert of the failure.

### Built With

- [Circle CI](www.circleci.com) - Cloud-based CI/CD service
- [Amazon AWS](https://aws.amazon.com/) - Cloud services
- [AWS CLI](https://aws.amazon.com/cli/) - Command-line tool for AWS
- Cloudformation - IAC for AWS
- [Terraform](https://https://www.terraform.io/) - Infrastrcuture as code
- [Ansible](https://www.ansible.com/) - Configuration management tool
- [Prometheus](https://prometheus.io/) - Monitoring tool

### License

[License](LICENSE.md)
