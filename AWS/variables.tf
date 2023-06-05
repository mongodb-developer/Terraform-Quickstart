variable "access_key" {
description = "AWS access key"
}

variable "secret_key" {
description = "AWS secret key"
}

variable "region" {
description = "AWS region"
default = "us-west-2" # Update with your desired region
}

variable "instance_count" {
description = "Number of MongoDB instances"
default = 3
}

variable "instance_type" {
description = "Instance type for MongoDB instances"
default = "t2.micro"
}

variable "ami" {
description = "AMI ID for MongoDB Community Edition"
default = "ami-0c94855ba95c71c99" # Update with the desired AMI
}

variable "security_group_ids" {
description = "List of security group IDs"
default = ["<SECURITY_GROUP_ID>"] # Update with your security group ID
}
