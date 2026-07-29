terraform {
  required_providers {
    routeros = {
      source = "terraform-routeros/routeros"
    }
  }
}

provider "routeros" {
  hosturl  = "http://192.168.88.1" # env ROS_HOSTURL or MIKROTIK_HOST
  insecure = true                  # env ROS_INSECURE or MIKROTIK_INSECURE
}

# resource "routeros_file" "test" {
#   name     = "test"
#   contents = "This is a test"
# }
