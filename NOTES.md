# Introduction

This is a simple code to build, test and deploy a containerized app on EKS via Github actions.

# Prerequisites
- A github account with AWS credentials as secrets
- Secrets configured in the cluster for DB_USER and DB_PASSWORD

# Descriptions
Repo has both the infrastructure, in the 'infra' directory, and the CI/CD parts.
The infrastructure is handled by the Terraform code which will deploy all necessary resources (Networking, RDS Postgres, EKS cluster and an S3 bucket for query results) in the correct order.
Considering that's an example I've added to the script a feature at the end which allow to delete all resources created to clean up.
The 'helm' directory contains the files to deploy the application which is built using the Dockerfile and stored in an AWS ECR repository, which is also created by Terraform.

# How to run
To run the code first execute Terraform as follows:

```
./provision_all.sh
```

When the script has completed the creation of all resources with Terraform it'll ask to destroy all, just skip if not necessary.

The new pipeline added 'build_and_deploy.yml' is configured to trigger at every push to main and at every pull request merge and will perform the following action

# Improvements
This is a simple code and is not what you expect to have in production therefore there are many optimisation tha can be done, here some examples:

- Improve secrets management as currently I've hardcoded DB user and pwd into the shell wrapper script
- Use OIDC/IAM roles instead of AWS credentials
- To simplify the code the docker container is built twice, first is tested and later pushed to ECR and that's logically not correct as you want to deliver the exact artifact that has been tested.
- Versions, CIDRs and other data are hardcoded while best would be to parametrize them and use variables
