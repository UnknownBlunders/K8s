set quiet
set shell := ['bash', '-euo', 'pipefail', '-c']

kubernetes_dir := justfile_dir() + '/kubernetes'
called_dir := invocation_directory()

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

[doc('Render the local kustomization to out.yaml. Can specify an output file number, for diffing')]
render number="":
    kustomize build {{ called_dir }} --enable-helm > {{ called_dir }}/out{{ number }}.yaml

[doc('Cleanup output files and downloaded charts after rendering a kustomization')]
cleanup-render:
    rm -r {{ called_dir }}/charts
    rm {{ called_dir }}/out*.yaml
