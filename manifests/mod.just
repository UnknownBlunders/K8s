set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']

kubernetes_dir := justfile_dir() + '/kubernetes'

[private]
default:
    just -l kube

[doc('Open a shell on a node')]
node-shell node:
    kubectl debug node/{{ node }} -n default -it --image="mirror.gcr.io/alpine:latest" --profile sysadmin
    kubectl delete pod -n default -l app.kubernetes.io/managed-by=kubectl-debug

[doc('Prune pods chosen phase. E.G. Failed, Pending, or Succeeded')]
prune-pods phase ns="":
    kubectl delete pods {{ if ns != "" { "-n " + ns } else { "-A" } }} --field-selector status.phase={{ phase }} --ignore-not-found=true
