# How to bootstrap this cluster:
## Order:
 - cilium
 - metal lb
 - cert-manager
 - ingress-nginx
 - cert-manager
 - argocd
## in each directory run
```kustomize build --enable-alpha-plugins --enable-exec --enable-helm | kubectl apply -f -```