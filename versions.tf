
terraform {
  required_version = ">= 1.14.5"
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = ">= 4.40, < 8"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.40, < 8"
    }
  }

}
