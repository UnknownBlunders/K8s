module "router-base" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/base"

  hostname = "10g"
  model    = "crs309"

  default_route = local.global.default_route
  dns_servers   = local.global.dns_servers

  # ===============================================================================================
  # Certificate Defaults
  # ===============================================================================================
  certificate_country      = local.global.certificate_country
  certificate_locality     = local.global.certificate_locality
  certificate_organization = local.global.certificate_organization
  certificate_unit         = local.global.certificate_unit
  certificate_common_name  = "10g"
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
    Management = merge(local.global.vlans.Management, { address = "192.168.8.15/24" })
  })

  ethernet_interfaces = {
    "ether1"       = { comment = "Eth Management", untagged = "Management" }
    "sfp-sfpplus1" = { comment = "KW01", untagged = "K8S" }
    "sfp-sfpplus2" = { comment = "KW02", untagged = "K8S" }
    "sfp-sfpplus3" = { comment = "Unused", untagged = "K8S" }
    "sfp-sfpplus4" = { comment = "Unused", untagged = "K8S" }
    "sfp-sfpplus5" = { comment = "Unused", untagged = "K8S" }
    "sfp-sfpplus6" = { comment = "Unused", untagged = "K8S" }
    "sfp-sfpplus7" = { comment = "KW03", untagged = "K8S" }
    "sfp-sfpplus8" = { comment = "Network Trunk", tagged = local.global.all_vlans }
  }
}
