variable "project" {
    default = "gcp101730-pulanowskisandbox"
    }

variable "region" {
    default = "us-central1"
    }

variable "zone" {
    default = "us-central1-c"
    }

variable "machine_type" {
    default = "e2-medium"
    }

variable "username" {
    default = "pulan@softserveinc.com"
}

variable "sshkey" {
    default = "~/.ssh/defaultssh.pub"

}
