
## Wiping rook-ceph without a re-boostrap

1. Delete both rook-ceph-cluster and rook-ceph-operator
2. Clean up any hanging finalizers

``` bash
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get -n rook-ceph --ignore-not-found --show-kind -o name | xargs -I {} kubectl patch {} -n rook-ceph -p '{"metadata":{"finalizers":null}}' --type=merge
```
3. Wipe the /var/lib/rook directory on the node's boot disk:

``` bash
kubectl debug -n kube-system -it --image alpine node/<node-name>
rm -r /host/var/lib/rook
```

4. Wipe the rook disk:

``` bash
talosctl get disk -n <node fqdn>
talosctl wipe disk <disk name / id> -n <node fqdn>
```
