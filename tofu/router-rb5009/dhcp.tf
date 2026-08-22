
module "TRUSTED" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dhcp-server"

  interface   = "Trusted"
  network     = "192.168.2.0/24"
  gateway     = "192.168.2.1"
  dhcp_pool   = ["192.168.2.20-192.168.2.240"]
  dns_servers = ["192.168.2.1"]
  # domain      = "TRUSTED.net.blunders.me"

  static_leases = {
    "192.168.2.152" = { name = "TPL-LivingRoom", mac = "34:60:f9:06:6d:a6" }
  }
}

module "DMZ" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dhcp-server"

  interface   = "DMZ"
  network     = "192.168.3.0/24"
  gateway     = "192.168.3.1"
  dhcp_pool   = ["192.168.3.30-192.168.3.240"]
  dns_servers = ["192.168.3.1"]

  static_leases = {
    "192.168.3.31" = { name = "satisfactory", mac = "1e:3b:24:bd:cc:ba" }
  }
}

module "IOT" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dhcp-server"

  interface   = "IOT"
  network     = "192.168.4.0/24"
  gateway     = "192.168.4.1"
  dhcp_pool   = ["192.168.4.50-192.168.4.200"]
  dns_servers = ["192.168.4.1"]

  static_leases = {
    "192.168.4.50"  = { name = "tom", mac = "d8:47:32:c1:f2:25" }
    "192.168.4.53"  = { name = "Bug-Lamp-1", mac = "c0:c9:e3:1a:01:34" }
    "192.168.4.54"  = { name = "Bug-Lamp-2", mac = "c0:c9:e3:1a:24:27" }
    "192.168.4.55"  = { name = "hogwartz", mac = "d8:47:32:c2:54:a9" }
    "192.168.4.56"  = { name = "Plant-light-1", mac = "c0:c9:e3:1a:3d:ec" }
    "192.168.4.57"  = { name = "officeLamp", mac = "d8:47:32:c2:6d:ec" }
    "192.168.4.59"  = { name = "Ethan-bedside", mac = "50:91:e3:a8:16:d7" }
    "192.168.4.60"  = { name = "Taylor-Bedside", mac = "50:91:e3:a7:ec:c1" }
    "192.168.4.61"  = { name = "wemo-chandellier", mac = "24:f5:a2:45:c8:e3" }
    "192.168.4.62"  = { name = "wemo-kitchen", mac = "24:f5:a2:45:c7:b9" }
    "192.168.4.63"  = { name = "left-basement", mac = "50:91:e3:a7:e5:3d" }
    "192.168.4.64"  = { name = "Right-Basement", mac = "50:91:e3:a8:19:93" }
    "192.168.4.84"  = { name = "Litter-Robot4", mac = "34:5f:45:ea:73:b4" }
    "192.168.4.85"  = { name = "AG-Ethan-Office", mac = "d8:3b:da:1c:85:4c" }
    "192.168.4.86"  = { name = "AG-Bedroom", mac = "d8:3b:da:1c:f0:c8" }
    "192.168.4.108" = { name = "lutron-caseta-hub", mac = "6c:c3:74:b7:2f:4e" }
  }
}

module "INT" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dhcp-server"

  interface   = "INT"
  network     = "192.168.5.0/24"
  gateway     = "192.168.5.1"
  dhcp_pool   = ["192.168.5.200-192.168.5.250"]
  dns_servers = ["192.168.5.1"]
}

module "K8S" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dhcp-server"

  interface   = "K8S"
  network     = "192.168.6.0/23"
  gateway     = "192.168.6.1"
  dhcp_pool   = ["192.168.6.200-192.168.6.250"]
  dns_servers = ["192.168.6.1"]
}

module "Management" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dhcp-server"

  interface   = "Management"
  network     = "192.168.8.0/24"
  gateway     = "192.168.8.1"
  dhcp_pool   = ["192.168.8.240-192.168.8.250"]
  dns_servers = ["192.168.8.1"]
}

module "IOT-Dead-End" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dhcp-server"

  interface   = "IOT-Dead-End"
  network     = "192.168.9.0/24"
  gateway     = "192.168.9.1"
  dhcp_pool   = ["192.168.9.100-192.168.9.240"]
  dns_servers = ["192.168.9.1"]

  static_leases = {
    "192.168.9.101" = { name = "AG-Ethan-Office", mac = "d8:3b:da:1c:85:4c" }
    "192.168.9.102" = { name = "AG-Bedroom", mac = "d8:3b:da:1c:f0:c8" }
    "192.168.9.103" = { name = "AG-Taylor-Office", mac = "d8:3b:da:1a:4d:8c" }
  }
}

module "TEST" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dhcp-server"

  interface   = "TEST"
  network     = "192.168.10.0/24"
  gateway     = "192.168.10.1"
  dhcp_pool   = ["192.168.10.100-192.168.10.240"]
  dns_servers = ["192.168.10.1"]
}
