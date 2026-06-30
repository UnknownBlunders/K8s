set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']

scripts_dir := justfile_dir() + '/scripts'
talos_dir := justfile_dir() + '/talos'
called_dir := invocation_directory()

[private]
default:
    just -l talos

genconfig:
    op run --env-file={{ talos_dir }}/.env -- talhelper genconfig

[confirm('Apply Talos config to ' + node + ' [y|N] ?')]
[doc('Apply Talos config to a node. Insecure if an IP is provided (Applying a new node)')]
apply-config node ip="":
    talosctl apply-config -n {{ if ip != "" { ip + " -i" } else { node + ".blunders.me" } }} -f {{ talos_dir }}/clusterconfig/prod-cluster-{{ node }}.blunders.me.yaml

[doc('Dry-run apply a Talos config to a node. Insecure if an IP is provided (Applying a new node)')]
dry-config node ip="":
    talosctl apply-config --dry-run -n {{ if ip != "" { ip + " -i" } else { node + ".blunders.me" } }} -f {{ talos_dir }}/clusterconfig/prod-cluster-{{ node }}.blunders.me.yaml
