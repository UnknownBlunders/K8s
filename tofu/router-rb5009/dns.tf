module "dns-server" {
  source = "git::https://github.com/unknownblunders/terraform-modules-routeros.git//modules/dns-server"

  upstream_dns = ["1.1.1.1", "8.8.8.8"]

  static_dns = {

    # ===== Network =====
    "router.blunders.me"  = { address = "192.168.8.1", type = "A" }
    "10g.blunders.me"     = { address = "192.168.8.15", type = "A" }
    "1g-rack.blunders.me" = { address = "192.168.8.11", type = "A" }

    "taylor-office-ap.blunders.me" = { address = "192.168.8.13", type = "A" }
    "ethan-office-ap"              = { address = "192.168.8.14", type = "A" }
    "taylor-office-switch"         = { address = "192.168.8.12", type = "A" }

    "zigbee.blunders.me" = { address = "192.168.5.4", type = "A" }

    # ===== Misc Services =====

    "pve.blunders.me"         = { address = "192.168.8.33", type = "A" }
    "nfs.blunders.me"         = { address = "192.168.5.3", type = "A" }
    "vpn.blunders.me"         = { address = "192.168.3.2", type = "A" }
    "mgmt-docker.blunders.me" = { address = "192.168.8.51", type = "A" }
    "omada.blunders.me"       = { cname = "mgmt-docker.blunders.me", type = "CNAME" }

    # ===== Kubernetes =====

    "cluster.blunders.me" = { address = "192.168.6.10", type = "A" }

    "kcp01.blunders.me" = { address = "192.168.6.11", type = "A" }
    "kcp02.blunders.me" = { address = "192.168.6.12", type = "A" }
    "kcp03.blunders.me" = { address = "192.168.6.13", type = "A" }

    "kw01.blunders.me" = { address = "192.168.6.14", type = "A" }
    "kw02.blunders.me" = { address = "192.168.6.15", type = "A" }
    "kw03.blunders.me" = { address = "192.168.6.16", type = "A" }

    # ===== Kubernetes Services =====

    "mc.blunders.me"          = { address = "192.168.7.2", type = "A" }
    "minecraft.blunders.me"   = { cname = "mc.blunders.me", type = "CNAME" }
    "*.mc.blunders.me"        = { cname = "mc.blunders.me", type = "CNAME" }
    "*.minecraft.blunders.me" = { cname = "mc.blunders.me", type = "CNAME" }

    "satisfactory.blunders.me" = { address = "192.168.7.4", type = "A" }

    "gw-int.blunders.me"    = { address = "192.168.7.5", type = "A" }
    "todo.blunders.me"      = { cname = "gw-int.blunders.me", type = "CNAME" }
    "bookshelf.blunders.me" = { cname = "gw-int.blunders.me", type = "CNAME" }
    "ha.blunders.me"        = { cname = "gw-int.blunders.me", type = "CNAME" }
    "photos.blunders.me"    = { cname = "gw-int.blunders.me", type = "CNAME" }
    "jellyfin.blunders.me"  = { cname = "gw-int.blunders.me", type = "CNAME" }
    "argocd.blunders.me"    = { cname = "gw-int.blunders.me", type = "CNAME" }
    "grafana.blunders.me"   = { cname = "gw-int.blunders.me", type = "CNAME" }
    "metrics.blunders.me"   = { cname = "gw-int.blunders.me", type = "CNAME" }
    "logs.blunders.me"      = { cname = "gw-int.blunders.me", type = "CNAME" }
    "hubble.blunders.me"    = { cname = "gw-int.blunders.me", type = "CNAME" }
    "paperless.blunders.me" = { cname = "gw-int.blunders.me", type = "CNAME" }
    "ceph.blunders.me"      = { cname = "gw-int.blunders.me", type = "CNAME" }
    "kopia.blunders.me"     = { cname = "gw-int.blunders.me", type = "CNAME" }
    "alerts.blunders.me"    = { cname = "gw-int.blunders.me", type = "CNAME" }
    "s3.blunders.me"        = { cname = "gw-int.blunders.me", type = "CNAME" }
    "garage.blunders.me"    = { cname = "gw-int.blunders.me", type = "CNAME" }
    "status.blunders.me"    = { cname = "gw-int.blunders.me", type = "CNAME" }
  }
}
