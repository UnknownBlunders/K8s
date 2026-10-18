set default-list
set default-script
set quiet
set script-interpreter := ['bash', '-euo', 'pipefail']
set shell := ['bash', '-euo', 'pipefail', '-c']

scripts_dir := justfile_dir() + '/scripts'
talos_dir := justfile_dir() + '/talos'
called_dir := invocation_directory()
topf_config := source_directory() / "topf.yaml"

[private]
default:
    just -l talos

[doc('Render machine configs for all nodes to a directory (default: out)')]
genconfig number="":
    topf --topfconfig "{{ topf_config }}" render -o "{{ talos_dir }}/out{{ number }}"

[confirm('Apply Talos config to ' + node + ' [y|N] ?')]
[doc('Apply Talos config to a node. Insecure if an IP is provided (Applying a new node)')]
apply-config node ip="":
    talosctl apply-config -n {{ if ip != "" { ip + " -i" } else { node + ".blunders.me" } }} -f {{ talos_dir }}/out/{{ node }}.yaml

[doc('Dry-run apply a Talos config to a node. Insecure if an IP is provided (Applying a new node)')]
dry-config node ip="":
    talosctl apply-config --dry-run -n {{ if ip != "" { ip + " -i" } else { node + ".blunders.me" } }} -f {{ talos_dir }}/out/{{ node }}.yaml
