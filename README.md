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
