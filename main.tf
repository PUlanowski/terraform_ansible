terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
}

#config default project in GCP

resource "null_resource" "health_check" {
    provisioner "local-exec"{
        command = "gcloud config set project ${var.project}"
        }
}

#creating network

resource "google_compute_network" "vpc_network" {
  name = "vpc-jenkins"
  auto_create_subnetworks = "true"
}



#creating firewall rules

resource "google_compute_firewall" "jenkins-ssh" {
  name = "jenkins-ssh"
  network = "vpc-jenkins"
  target_tags = ["jenkinsmachine"]
  source_ranges = ["0.0.0.0/0"]
  depends_on = ["google_compute_network.vpc_network"]

  allow {
    protocol = "tcp"
    ports = ["22", "80", "443", "8080-8090"]
  }

}

#creating GCE

resource "google_compute_instance" "jenkins-vm" {
    name = "jenkins-machine"
    machine_type = var.machine_type
    zone = var.zone

    tags = ["jenkinsmachine"]

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11"
        }
    }
    
    network_interface {
        network = google_compute_network.vpc_network.self_link
    
    access_config {
      // Ephemeral public IP
    }
    
  }

    metadata = {
        ssh-keys = "${var.username}:${file(var.sshkey)}"
    }
  
  depends_on = ["google_compute_firewall.jenkins-ssh"]
}
