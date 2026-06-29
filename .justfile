#!/usr/bin/env -S just --justfile

set quiet := true
set shell := ['bash', '-euo', 'pipefail', '-c']

mod talos "talos"
mod kube "manifests"

[private]
default:
    just -l
