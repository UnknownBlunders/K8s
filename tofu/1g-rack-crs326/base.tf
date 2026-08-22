module "crs326-1g-rack-base" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/base"

  hostname = "1g-rack"
  model    = "crs326"

  default_route = local.global.default_route
  dns_servers   = local.global.dns_servers

  # ===============================================================================================
  # Certificate Defaults
  # ===============================================================================================
  certificate_country      = local.global.certificate_country
  certificate_locality     = local.global.certificate_locality
  certificate_organization = local.global.certificate_organization
  certificate_unit         = local.global.certificate_unit
  certificate_common_name  = "1g-rack"
  # ===============================================================================================
  # Device Defaults
  # ===============================================================================================
  timezone              = local.global.timezone
  ntp_servers           = local.global.ntp_servers
  disable_ipv6          = local.global.disable_ipv6
  mac_server_interfaces = local.global.mac_server_interfaces

  # ===============================================================================================
  # Default Groups and Users
  # ===============================================================================================
  groups = local.global.groups
  users  = local.global.users

  # ===============================================================================================
  # VLAN Definitions
  # ===============================================================================================
  vlans = merge(local.global.vlans, {
    Management = merge(local.global.vlans.Management, { address = "192.168.8.11/24" })
  })

  ethernet_interfaces = {
    "ether1"       = { comment = "Network Trunk to router-rb5009", tagged = local.global.all_vlans }
    "ether2"       = { comment = "Network Trunk to Ethan-Office-AP", tagged = local.global.all_but_management_vlans, untagged = "Management" }
    "ether3"       = { comment = "Unused", untagged = "Management" }
    "ether4"       = { comment = "Unused", untagged = "Management" }
    "ether5"       = { comment = "Unused", untagged = "Management" }
    "ether6"       = { comment = "Unused", untagged = "Management" }
    "ether7"       = { comment = "Unused", untagged = "Management" }
    "ether8"       = { comment = "NAS", untagged = "INT" }
    "ether9"       = { comment = "Printer", untagged = "Trusted" }
    "ether10"      = { comment = "Network Trunk to VMs", tagged = local.global.all_vlans }
    "ether11"      = { comment = "Unused", untagged = "Management" }
    "ether12"      = { comment = "Unused", untagged = "Management" }
    "ether13"      = { comment = "Unused", untagged = "Trusted" }
    "ether14"      = { comment = "Unused", untagged = "DMZ" }
    "ether15"      = { comment = "Unused", untagged = "INT" }
    "ether16"      = { comment = "Unused", untagged = "K8S" }
    "ether17"      = { comment = "Unused", untagged = "IOT" }
    "ether18"      = { comment = "Unused", untagged = "IOT-Dead-End" }
    "ether19"      = { comment = "Unused", untagged = "TEST" }
    "ether20"      = { comment = "kcp01", untagged = "K8S" }
    "ether21"      = { comment = "Unused", untagged = "Management" }
    "ether22"      = { comment = "kcp02", untagged = "K8S" }
    "ether23"      = { comment = "Unused", untagged = "Management" }
    "ether24"      = { comment = "kcp03", untagged = "K8S" }
    "sfp-sfpplus1" = { comment = "Network Trunk to 10g-crs309", tagged = local.global.all_vlans }
    "sfp-sfpplus2" = { comment = "Future Unused Network Trunk", tagged = local.global.all_vlans }
  }
}
