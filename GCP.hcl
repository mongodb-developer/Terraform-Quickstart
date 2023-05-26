# Provider configuration for GCP
provider "google" {
  credentials = file("path/to/service-account-key.json")
  project     = "your-project-id"
  region      = "us-central1"   # Update with your desired region
}

# Compute instances
resource "google_compute_instance" "mongodb" {
  count        = 3
  name         = "mongodb-instance-${count.index}"
  machine_type = "e2-medium"   # Update with your desired machine type
  zone         = "us-central1-a"   # Update with your desired zone
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.mongodb[count.index].address
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "rs.initiate({_id: 'rs0', members: [{ _id: 0, host: 'mongodb-instance-0:27017' }, { _id: 1, host: 'mongodb-instance-1:27017' }, { _id: 2, host: 'mongodb-instance-2:27017' }]})" | mongo --port 27017
  EOT
}

# External IP addresses
resource "google_compute_address" "mongodb" {
  count = 3
  name  = "mongodb-ip-${count.index}"
}

# Firewall rule to allow MongoDB traffic
resource "google_compute_firewall" "mongodb" {
  name    = "mongodb-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_ranges = ["0.0.0.0/0"]
}
