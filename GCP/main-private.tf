# Provider configuration for GCP
provider "google" {
  credentials = file("path/to/service-account-key.json")
  project     = "your-project-id"
  region      = "us-central1"   # Update with your desired region
}

# VPC Network
resource "google_compute_network" "mongodb_network" {
  name                    = "mongodb-network"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "mongodb_subnet" {
  name          = "mongodb-subnet"
  region        = "us-central1"   # Update with your desired region
  network       = google_compute_network.mongodb_network.self_link
  ip_cidr_range = "10.0.0.0/24"   # Update with your desired CIDR range
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
    network                 = google_compute_network.mongodb_network.self_link
    subnetwork              = google_compute_subnetwork.mongodb_subnet.self_link
    access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "rs.initiate({_id: 'rs0', members: [{ _id: 0, host: 'mongodb-instance-0:27017' }, { _id: 1, host: 'mongodb-instance-1:27017' }, { _id: 2, host: 'mongodb-instance-2:27017' }]})" | mongo --port 27017
  EOT
}

# Private service connection
resource "google_service_networking_connection" "mongodb_connection" {
  network                 = google_compute_network.mongodb_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["10.0.1.0/24"]   # Update with your desired CIDR range

  depends_on = [
    google_compute_network.mongodb_network
  ]
}

# Firewall rule to allow MongoDB traffic
resource "google_compute_firewall" "mongodb" {
  name    = "mongodb-firewall"
  network = google_compute_network.mongodb_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_ranges = ["10.0.1.0/24"]   # Update with your desired CIDR range

  depends_on = [
    google_service_networking_connection.mongodb_connection
  ]
}
