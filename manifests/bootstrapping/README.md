# How to bootstrap this cluster:
## Order:
 - cilium
 - metal lb
 - cert-manager
 - ingress-nginx
 - cert-manager
 - argocd
## in each directory run
```kubectl kustomize . --enable-helm | kubectl apply -f -```