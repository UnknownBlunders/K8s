terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
    }
    onepassword = {
      source  = "1password/onepassword"
      version = ">=3.3.1"
    }
  }

  backend "s3" {
    bucket                      = "blunderstofustate"
    region                      = "us-east-1"
    endpoint                    = "s3.us-west-002.backblazeb2.com"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    use_path_style              = true
    key                         = "10g-crs309"
  }

}

provider "routeros" {
  # hosturl = "http://192.168.88.1"
  hosturl  = "https://10g.blunders.me"
  insecure = true
}

locals {
  # Load and convert the YAML string into a Terraform object
  global = yamldecode(file("${path.module}/../globals.yaml"))
}
