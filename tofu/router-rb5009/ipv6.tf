# my ula address pool.
# Get your own (randomly generate one) here: https://unique-local-ipv6.com/#
#
# from the above site: 
# Unlike their IPv4 counterpart, IPv6 local addresses have a 40-bit random part, 
# which makes them unique. The goal of IPv6 local addresses is that if you connect
# two private IPv6 networks together - such as two private sites connected over VPN - 
# it should be very unlikely that you will run into addressing conflicts.
locals {
  ula_base = "fd70:9ddd:499f"
}

module "Trusted-ipv6" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/ipv6-addressing"
  # source = "../../../terraform-modules-routeros/modules/ipv6-addressing"

  lan_interface = "Trusted"
  mac_suffix    = "02"
  ula_subnet    = "2"
  ula_base      = local.ula_base

  core_network = true
}

module "IOT-ipv6" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/ipv6-addressing"

  lan_interface = "IOT"
  mac_suffix    = "04"
  ula_subnet    = "4"
  ula_base      = local.ula_base
}

module "IOTDE-ipv6" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/ipv6-addressing"

  lan_interface = "IOT-Dead-End"
  mac_suffix    = "09"
  ula_subnet    = "9"
  ula_base      = local.ula_base

  enable_gua = false
}

module "TEST-ipv6" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/ipv6-addressing"

  lan_interface = "TEST"
  mac_suffix    = "10"
  ula_subnet    = "10"
  ula_base      = local.ula_base

  advertise_ula = false
}

# coming soon to a vlan near you:

# module "INT-ipv6" {
#   source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/ipv6-addressing"

#   lan_interface = "INT"
#   mac_suffix    = "05"
#   ula_subnet    = "5"
#   ula_base      = local.ula_base
# }

# module "K8S-ipv6" {
#   source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/ipv6-addressing"

#   lan_interface = "K8S"
#   mac_suffix    = "06"
#   ula_subnet    = "6"
#   ula_base      = local.ula_base

#   advertise_ula = false
# }

# module "Management-ipv6" {
#   source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/ipv6-addressing"

#   lan_interface = "Management"
#   mac_suffix    = "08"
#   ula_subnet    = "8"
#   ula_base      = local.ula_base

#   advertise_ula = false
# }
