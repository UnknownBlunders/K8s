# How to bootstrap this cluster:
## Order:
 - cilium
 - metal lb
 - cert-manager
 - ingress-nginx
 - argocd
## in each directory run
```kustomize build --enable-alpha-plugins --enable-exec --enable-helm | kubectl apply -f -```

## Then add apps
In bootstrapping/argo-appsets run:
```kubectl apply -k .```
And do the same in apps/argo-appsets.