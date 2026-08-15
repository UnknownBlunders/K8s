module "firewall" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/firewall"

  # ===============================================================================================
  # Interface Lists
  # ===============================================================================================
  interface_lists = {
    WAN = {
      comment    = "Public-facing uplink"
      interfaces = ["ether1"]
    }
    LAN = {
      comment    = "All internal VLANs"
      interfaces = ["Trusted", "DMZ", "IOT", "INT", "K8S", "Management", "IOT-Dead-End"]
    }
    Isolated = {
      comment    = "VLANs with no internet or cross-VLAN access"
      interfaces = ["IOT-Dead-End"]
    }
  }

  # ===============================================================================================
  # Address Lists
  # ===============================================================================================
  address_lists = {
    rfc1918 = {
      comment   = "All RFC1918 private ranges"
      addresses = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    }
    bogons = {
      comment = "Bogon / martian source addresses that should never appear on WAN"
      addresses = [
        "0.0.0.0/8",
        "10.0.0.0/8",
        "127.0.0.0/8",
        "169.254.0.0/16",
        "172.16.0.0/12",
        "192.168.0.0/16",
        "224.0.0.0/4",
        "240.0.0.0/4",
      ]
    }
    k8s = {
      comment   = "Kubernetes node/pod ranges"
      addresses = ["192.168.6.0/23"]
    }
    k8s-service-lb = {
      comment   = "Kubernetes LoadBalancer / port-forward targets"
      addresses = ["192.168.7.1"]
    }
    minecraft = {
      comment   = "Minecraft server (port-forward target)"
      addresses = ["192.168.7.2"]
    }
    nfs-server = {
      addresses = ["192.168.5.3"]
    }
    zigbee = {
      addresses = ["192.168.5.4"]
    }
    hdhomerun = {
      addresses = ["192.168.2.219"]
    }
  }

  # ===============================================================================================
  # Filter Rules
  #
  # Design:
  #   - Default deny on both input and forward chains.
  #   - Fasttrack + accept established/related as the very first rules for performance.
  #   - Router (input) is only reachable for services from the Trusted VLAN.
  #   - Every non-Trusted VLAN can only reach the internet (out=WAN); cross-VLAN
  #     traffic is denied unless explicitly allowlisted.
  #   - IOT-Dead-End has NO internet and NO cross-VLAN access (return traffic only).
  #   - WAN can only reach the LAN via traffic that was DSTNATed (port forwards).
  # ===============================================================================================
  filter_rules = {

    # ------------------------------------------------------------
    # INPUT chain -- traffic destined for the router itself
    # ------------------------------------------------------------
    "input-accept-established" = {
      chain            = "input"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 100
      comment          = "Accept established/related/untracked"
    }
    "input-drop-invalid" = {
      chain            = "input"
      action           = "drop"
      connection_state = "invalid"
      order            = 110
      comment          = "Drop invalid"
    }
    "input-accept-icmp" = {
      chain    = "input"
      action   = "accept"
      protocol = "icmp"
      order    = 120
      comment  = "Accept ICMP (ping / PMTUD)"
    }
    "input-drop-bogons-from-wan" = {
      chain             = "input"
      action            = "drop"
      in_interface_list = "WAN"
      src_address_list  = "bogons"
      order             = 130
      comment           = "Drop bogon/martian sources from WAN"
    }
    "input-accept-dhcp-from-lan" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "67,68"
      in_interface_list = "LAN"
      order             = 200
      comment           = "Accept DHCP from internal VLANs"
    }
    "input-accept-dns-udp-from-lan" = {
      chain             = "input"
      action            = "accept"
      protocol          = "udp"
      dst_port          = "53"
      in_interface_list = "LAN"
      order             = 210
      comment           = "Accept DNS (UDP) from internal VLANs"
    }
    "input-accept-dns-tcp-from-lan" = {
      chain             = "input"
      action            = "accept"
      protocol          = "tcp"
      dst_port          = "53"
      in_interface_list = "LAN"
      order             = 220
      comment           = "Accept DNS (TCP) from internal VLANs"
    }
    "input-accept-mgmt-from-trusted" = {
      chain        = "input"
      action       = "accept"
      protocol     = "tcp"
      dst_port     = "22,80,443,8291,8728,8729"
      in_interface = "Trusted"
      order        = 300
      comment      = "SSH / WebFig / Winbox API/ from Trusted"
    }
    "input-accept-mgmt-from-management" = {
      chain        = "input"
      action       = "accept"
      protocol     = "tcp"
      dst_port     = "22,80,443,8291,8728,8729"
      in_interface = "Management"
      order        = 310
      comment      = "SSH / WebFig / Winbox API/ from Management"
    }
    "input-drop-all" = {
      chain   = "input"
      action  = "drop"
      order   = 900
      comment = "Drop everything else destined for the router"
    }

    # ------------------------------------------------------------
    # FORWARD chain -- traffic transiting the router
    # ------------------------------------------------------------
    "forward-fasttrack" = {
      chain            = "forward"
      action           = "fasttrack-connection"
      connection_state = "established,related"
      #hw_offload       = true
      order   = 1000
      comment = "Fasttrack established/related for performance"
    }
    "forward-accept-established" = {
      chain            = "forward"
      action           = "accept"
      connection_state = "established,related,untracked"
      order            = 1010
      comment          = "Accept established/related/untracked"
    }
    "forward-drop-invalid" = {
      chain            = "forward"
      action           = "drop"
      connection_state = "invalid"
      order            = 1020
      comment          = "Drop invalid"
    }
    "forward-drop-bogons-from-wan" = {
      chain             = "forward"
      action            = "drop"
      in_interface_list = "WAN"
      src_address_list  = "bogons"
      order             = 1030
      comment           = "Drop bogon/martian sources from WAN"
    }

    # --- WAN inbound: only allow traffic that was explicitly DSTNATed ---------
    "forward-drop-wan-not-dstnat" = {
      chain             = "forward"
      action            = "drop"
      in_interface_list = "WAN"
      order             = 1100
      comment           = "Drop WAN->LAN unless DSTNATed by a port-forward"
    }

    # --- Isolate IOT-Dead-End (no new outbound anywhere) ----------------------
    "forward-drop-isolated" = {
      chain             = "forward"
      action            = "drop"
      in_interface_list = "Isolated"
      order             = 1200
      comment           = "IOT-Dead-End: no new outbound (return traffic only)"
    }

    # --- Trusted VLAN: unrestricted ------------------------------------------
    "forward-accept-trusted" = {
      chain        = "forward"
      action       = "accept"
      in_interface = "Trusted"
      order        = 1300
      comment      = "Trusted can reach anything"
    }

    # --- Explicit cross-VLAN allowances (before RFC1918 block) ---------------
    "forward-mgmt-to-trusted" = {
      chain        = "forward"
      action       = "accept"
      in_interface = "Management"
      dst_address  = "192.168.2.0/24"
      order        = 1400
      comment      = "Management -> Trusted (PVE migration, backups)"
    }
    "forward-int-to-iot" = {
      chain        = "forward"
      action       = "accept"
      in_interface = "INT"
      dst_address  = "192.168.4.0/24"
      order        = 1410
      comment      = "INT -> IOT (services controlling IoT devices)"
    }
    "forward-dmz-to-k8s" = {
      chain            = "forward"
      action           = "accept"
      in_interface     = "DMZ"
      dst_address_list = "k8s"
      order            = 1420
      comment          = "DMZ (VPN) -> K8s services"
    }
    "forward-k8s-to-nfs" = {
      chain            = "forward"
      action           = "accept"
      in_interface     = "K8S"
      dst_address_list = "nfs-server"
      protocol         = "tcp"
      dst_port         = "111,2049"
      order            = 1430
      comment          = "K8s -> NFS server (TCP)"
    }
    "forward-k8s-to-nfs-udp" = {
      chain            = "forward"
      action           = "accept"
      in_interface     = "K8S"
      dst_address_list = "nfs-server"
      protocol         = "udp"
      dst_port         = "111,2049"
      order            = 1431
      comment          = "K8s -> NFS server (UDP)"
    }
    "forward-k8s-to-zigbee" = {
      chain            = "forward"
      action           = "accept"
      in_interface     = "K8S"
      dst_address_list = "zigbee"
      order            = 1440
      comment          = "K8s -> Zigbee coordinator"
    }
    "forward-k8s-to-hdhomerun" = {
      chain            = "forward"
      action           = "accept"
      in_interface     = "K8S"
      dst_address_list = "hdhomerun"
      order            = 1450
      comment          = "K8s -> HDHomeRun tuner"
    }
    "forward-k8s-to-iot" = {
      chain        = "forward"
      action       = "accept"
      in_interface = "K8S"
      dst_address  = "192.168.4.0/24"
      order        = 1460
      comment      = "K8s -> IOT (Home Assistant)"
    }
    "forward-k8s-to-iotde" = {
      chain        = "forward"
      action       = "accept"
      in_interface = "K8S"
      dst_address  = "192.168.9.0/24"
      order        = 1470
      comment      = "K8s HA/VM -> IOT-Dead-End"
    }

    # --- Block remaining cross-VLAN traffic ----------------------------------
    "forward-drop-inter-vlan" = {
      chain            = "forward"
      action           = "drop"
      src_address_list = "rfc1918"
      dst_address_list = "rfc1918"
      order            = 1800
      comment          = "Drop all remaining inter-VLAN / RFC1918<->RFC1918 traffic"
    }

    # --- Internet egress ------------------------------------------------------
    "forward-accept-to-wan" = {
      chain              = "forward"
      action             = "accept"
      out_interface_list = "WAN"
      order              = 1900
      comment            = "Accept internal -> WAN"
    }

    # --- Default deny ---------------------------------------------------------
    "forward-drop-all" = {
      chain   = "forward"
      action  = "drop"
      order   = 2000
      comment = "Default deny"
    }
  }

  # ===============================================================================================
  # NAT Rules
  # ===============================================================================================
  nat_rules = {

    # --- SRCNAT: masquerade internal traffic going to the internet -----------
    "masquerade-wan" = {
      chain              = "srcnat"
      action             = "masquerade"
      out_interface_list = "WAN"
      order              = 100
      comment            = "Masquerade all outbound WAN traffic"
    }

    # --- SRCNAT: hairpin NAT for port-forward targets ------------------------
    # Rewrites the source of internal->port-forward-target traffic so replies
    # come back through the router (required when accessing services by their
    # public name from inside the LAN).
    "hairpin-k8s-lb" = {
      chain            = "srcnat"
      action           = "masquerade"
      src_address_list = "rfc1918"
      dst_address_list = "k8s-service-lb"
      order            = 200
      comment          = "Hairpin NAT for K8s LB port-forwards"
    }
    "hairpin-minecraft" = {
      chain            = "srcnat"
      action           = "masquerade"
      src_address_list = "rfc1918"
      dst_address_list = "minecraft"
      order            = 210
      comment          = "Hairpin NAT for Minecraft"
    }

    # --- DSTNAT: port forwards from WAN --------------------------------------
    "dstnat-minecraft-tcp" = {
      chain             = "dstnat"
      action            = "dst-nat"
      in_interface_list = "WAN"
      protocol          = "tcp"
      dst_port          = "25565"
      to_addresses      = "192.168.7.2"
      to_ports          = "25565"
      order             = 500
      comment           = "Minecraft (TCP)"
    }
    "dstnat-minecraft-udp" = {
      chain             = "dstnat"
      action            = "dst-nat"
      in_interface_list = "WAN"
      protocol          = "udp"
      dst_port          = "25565"
      to_addresses      = "192.168.7.2"
      to_ports          = "25565"
      order             = 510
      comment           = "Minecraft (UDP)"
    }
    "dstnat-http" = {
      chain             = "dstnat"
      action            = "dst-nat"
      in_interface_list = "WAN"
      protocol          = "tcp"
      dst_port          = "80"
      to_addresses      = "192.168.7.1"
      to_ports          = "80"
      order             = 520
      comment           = "HTTP -> K8s ingress"
    }
    "dstnat-https" = {
      chain             = "dstnat"
      action            = "dst-nat"
      in_interface_list = "WAN"
      protocol          = "tcp"
      dst_port          = "443"
      to_addresses      = "192.168.7.1"
      to_ports          = "443"
      order             = 530
      comment           = "HTTPS -> K8s ingress"
    }
  }
}
