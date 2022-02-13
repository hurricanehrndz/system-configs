
terraform {
  required_version = ">= 1.1"
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.1"
    }
    ct = {
      source = "poseidon/ct"
      version = "0.9.1"
    }
  }
}

