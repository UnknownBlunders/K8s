module "router-base" {
  # source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/base?ref=v0.4.0"
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/base"
  # source = "../../../terraform-modules-routeros/modules/base"

  hostname = "router"
  model    = "rb5009"

  # ===============================================================================================
  # Certificate Defaults
  # ===============================================================================================
  certificate_country      = local.global.certificate_country
  certificate_locality     = local.global.certificate_locality
  certificate_organization = local.global.certificate_organization
  certificate_unit         = local.global.certificate_unit
  certificate_common_name  = "router"
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
    Trusted    = merge(local.global.vlans.Trusted, { address = "192.168.2.1/24" })
    DMZ        = merge(local.global.vlans.DMZ, { address = "192.168.3.1/24" })
    IOT        = merge(local.global.vlans.IOT, { address = "192.168.4.1/24" })
    INT        = merge(local.global.vlans.INT, { address = "192.168.5.1/24" })
    K8S        = merge(local.global.vlans.K8S, { address = "192.168.6.1/23" })
    Management = merge(local.global.vlans.Management, { address = "192.168.8.1/24" })
    IOTDE      = merge(local.global.vlans.IOTDE, { address = "192.168.9.1/24" })
  })

  ethernet_interfaces = {
    "ether1"       = { comment = "Internet Uplink", bridge_port = false }
    "ether2"       = { comment = "Taylors Office", tagged = local.global.all_but_management_vlans, untagged = "Management" }
    "ether3"       = { comment = "Backup Management", untagged = "Management" }
    "ether4"       = {}
    "ether5"       = {}
    "ether6"       = {}
    "ether7"       = { comment = "Backup Trusted", untagged = "Trusted" }
    "ether8"       = { comment = "Temp Rack Uplink", tagged = local.global.all_vlans }
    "sfp-sfpplus1" = {}
  }
}
