module "wireguard-server" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/wireguard-server"

  name        = "wg1"
  address     = "172.16.24.1/24"
  listen_port = 13231
  comment     = "WireGuard VPN server"
}

module "wireguard-peers" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/wireguard-peers"

  interface = module.wireguard-server.name

  peers = {
    "ethansphone" = { allowed_address = ["172.16.24.11/32"], comment = "EthansPhone" }
  }
}
