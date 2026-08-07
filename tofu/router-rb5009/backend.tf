terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
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
    key                         = "rb5009"
  }

}

provider "routeros" {
  # hosturl = "https://router.blunders.me"
  hosturl  = "https://192.168.8.1" # env ROS_HOSTURL or MIKROTIK_HOST
  insecure = true                  # env ROS_INSECURE or MIKROTIK_INSECURE
}
