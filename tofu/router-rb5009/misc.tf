# ===============================================================================================
# AT&T Fiber Gateway Management Access
#
# The AT&T gateway is in IP-passthrough mode, so ether1 (WAN) receives the public
# IP via DHCP. The gateway itself, however, keeps its management interface on
# 192.168.1.254 in the 192.168.1.0/24 subnet. To reach it from behind the router
# we give ether1 a second, directly-connected IP in that subnet so the router has
# a route and a valid source address for 192.168.1.0/24.
#
# The matching srcnat masquerade rule lives in firewall.tf ("masquerade-att-gateway")
# so LAN clients get a valid return path. Management is only permitted from the
# Trusted VLAN by the firewall's forward chain.
# ===============================================================================================

resource "routeros_ip_address" "att_gateway_mgmt" {
  address   = "192.168.1.2/24"
  network   = "192.168.1.0"
  interface = "ether1"
  comment   = "AT&T gateway management (reach 192.168.1.254)"
}

# ===============================================================================================
# WAN DHCP Client
# ===============================================================================================
resource "routeros_ip_dhcp_client" "wan" {
  interface         = "ether1"
  add_default_route = "yes"
  use_peer_dns      = false
  use_peer_ntp      = false
  disabled          = false
  comment           = "WAN uplink (AT&T passthrough public IP)"
}

module "mikrotik-cloud" {
  source               = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/cloud"
  ddns_enabled         = true
  ddns_update_interval = "1m"
}
