# AWS CodePipeline Provisioning with Terraform

This repository contains Terraform configurations for provisioning Auto Scaling groups and SNS topics on AWS.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (version >= 0.12)
- AWS CLI configured with appropriate IAM permissions
- An AWS account

## Setup

1. **Clone the repository**

   -> git clone https://github.com/Messites/aws-codepipeline-terraform.git
   
   -> cd aws-codepipeline-terraform

3. **Initialize Terraform**

    -> terraform init

4. **Review and modify variables**

    -> terraform init

5. **Plan the Deployment**

    -> terraform plan

6. **Apply the Deployment**

    -> terraform apply

7. **Clean up whenever necessary**

    -> terraform destroy

## Troubleshooting
If you encounter any issues, please check the following:

- Ensure your AWS CLI is configured correctly and you have the necessary permissions.
- Verify that your Terraform configurations are correct and all required variables are set.
- Check the AWS Management Console for any errors related to the resources being created.

## Contributing
Feel free to customize this `README.md` file according to your specific requirements and project details.

