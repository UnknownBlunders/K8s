#!/usr/bin/env -S just --justfile

set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']

mod talos "talos"
mod kube "manifests"
mod tf "tofu"

[private]
default:
    just -l

[doc('Test lefthook config. By default, runs pre-commit lefthook commands on staged files')]
test-hook hook-name="pre-commit":
    lefthook run {{ hook-name }}
