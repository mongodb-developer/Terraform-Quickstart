# Provider configuration for AWS
provider "aws" {
  access_key = "<AWS_ACCESS_KEY>"
  secret_key = "<AWS_SECRET_KEY>"
  region     = "us-west-2"   # Update with your desired region
}

# Resource definitions
resource "aws_instance" "mongodb" {
  count         = 3
  instance_type = "t2.micro"
  ami           = "ami-0c94855ba95c71c99"  # MongoDB Community Edition AMI

  tags = {
    Name = "mongodb-instance-${count.index}"
  }

  # Security group settings
  vpc_security_group_ids = ["<SECURITY_GROUP_ID>"]  # Update with your security group ID

  # User data script for MongoDB replica set configuration
  user_data = <<-EOF
              #!/bin/bash
              echo "rs.initiate({_id: 'rs0', members: [{ _id: 0, host: '${aws_instance.mongodb.0.private_ip}:27017' }, { _id: 1, host: '${aws_instance.mongodb.1.private_ip}:27017' }, { _id: 2, host: '${aws_instance.mongodb.2.private_ip}:27017' }]})" | mongo
              EOF
}

# Output variables
output "mongodb_connection_string" {
  value = "mongodb://${aws_instance.mongodb.0.private_ip}:27017,${aws_instance.mongodb.1.private_ip}:27017,${aws_instance.mongodb.2.private_ip}:27017/?replicaSet=rs0"
}
