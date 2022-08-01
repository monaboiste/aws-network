# Amazon Virtual Private Cloud
The repository contains all the infrastructure code needed to create a VPC on Amazon Cloud.

## Prerequisites
- aws account
- aws access keys setup
- terraform v1.2.0 (or higher)

## How to

### AWS resources' state storage

Provision of the aws resources is automated via terraform tool. We want to store the terraform state on aws s3 bucket,
so each user can download and access it on his/her local machine. We also want to guarantee that there will be no 
multiple mutation state requests from different users for the same resource. In order to fulfill this requirement,
we use DynamoDB for user locking.

The very first thing, we need to initialize the backend, which will be storing state of all resources:

```bash
cd infrastructure/terraform/backend
terraform init
terraform plan -out plan
terraform apply "plan"
```

### Provision VPC

After we created the state storage, we can proceed with vpc provision in the Ireland region:

```bash
cd infrastructure/terraform/ireland
terraform init
terraform plan -out plan
terraform apply "plan"
```

### Initialize backend in your infrastructure
To store terraform state of your aws resources, simply add the ``provider.tf`` file with the following content:

```hcl
terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.24.0"
    }
  }

  backend "s3" {
    bucket         = "monaboiste-terraform-state"
    key            = "vpc/ireland/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "monaboiste-terraform-state-locks"
    encrypt        = true
  }
}
```
