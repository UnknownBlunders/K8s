module "hex-poe" {
  # source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/base?ref=v0.4.0"
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/base"

  hostname    = "router"
  timezone    = "America/Chicago"
  ntp_servers = ["time.cloudflare.com"]

  # ===============================================================================================
  # Certificate Defaults
  # ===============================================================================================
  certificate_country      = "US"
  certificate_locality     = "Illinois"
  certificate_organization = "UnknownBlunders"
  certificate_unit         = "HOME"
  certificate_common_name  = "router"
  # ===============================================================================================
  # Device Defaults
  # ===============================================================================================
  disable_ipv6          = true
  mac_server_interfaces = "none"

  # ===============================================================================================
  # Default Groups and Users
  # ===============================================================================================
  groups = {
    metrics = { policies = ["api", "read"], comment = "Metrics collection group" }
  }
  users = {
    metrics = { group = "metrics", comment = "Prometheus metrics user", inactivity_policy = "logout", inactivity_timeout = "00:05:00" }
    ethan   = { group = "full", comment = "me, lol", inactivity_policy = "logout", inactivity_timeout = "00:05:00" }
  }

  # ===============================================================================================
  # VLAN Definitions
  # ===============================================================================================
  #   all_vlans                = keys(vlans)
  #   all_but_management_vlans = [for name, vlan in vlans : vlan.name if name != "Management"]
  vlans = {
    Trusted    = { name = "Trusted", vlan_id = 1969 }
    Untrusted  = { name = "Untrusted", vlan_id = 1942 }
    Guest      = { name = "Guest", vlan_id = 1742 }
    Services   = { name = "Services", vlan_id = 1010 }
    Management = { name = "Management", vlan_id = 1000 }
    Storage    = { name = "Storage", vlan_id = 1255 }
  }
}
