# Notice: Repository Deprecation
This repository is deprecated and no longer actively maintained. It contains outdated code examples or practices that do not align with current MongoDB best practices. While the repository remains accessible for reference purposes, we strongly discourage its use in production environments.
Users should be aware that this repository will not receive any further updates, bug fixes, or security patches. This code may expose you to security vulnerabilities, compatibility issues with current MongoDB versions, and potential performance problems. Any implementation based on this repository is at the user's own risk.
For up-to-date resources, please refer to the [MongoDB Developer Center](https://mongodb.com/developer).

# Terraform MongoDB Cluster Repository

This Terraform repository provides infrastructure-as-code (IaC) configurations to deploy MongoDB clusters on AWS, Azure, and GCP. The repository contains HCL (HashiCorp Configuration Language) code samples for each cloud provider to automate the provisioning and configuration of MongoDB clusters.

## Prerequisites

Before using this repository, make sure you have the following prerequisites:

- Terraform installed on your local machine
- AWS, Azure, or GCP account credentials and access keys

## Repository Structure

The repository has the following structure:

```
terraform-mongodb-cluster/
├── aws/
│ └── main.tf
├── azure/
│ └── main.tf
└── gcp/
└── main.tf
```

- The `aws` directory contains the Terraform configuration files for deploying a MongoDB cluster on AWS.
- The `azure` directory contains the Terraform configuration files for deploying a MongoDB cluster on Azure.
- The `gcp` directory contains the Terraform configuration files for deploying a MongoDB cluster on GCP.

[Provider Documentation](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest)
