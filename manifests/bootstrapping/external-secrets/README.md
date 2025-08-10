# Deploying:

apply the root kustomization: 

``` bash
kbuild | k apply -f -
```

Download the 1password connect credentials secret from 1password ( secret named `Home-Talos-Prod Credentials File op credentials external secrets connect server` with secret yaml attached) and apply it

``` bash
k apply -f ~/Downloads/op-credentials.yaml && rm ~/Downloads/op-credentials.yaml
```

Download the external secrets access token secret from 1password ( secret named `Home-Talos-Prod Access Token: External-secrets` with secret yaml attached) and apply it

``` bash
k apply -f ~/Downloads/es-access-token..yaml && rm ~/Downloads/es-access-token.yaml
```