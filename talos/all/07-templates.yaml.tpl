---
apiVersion: v1alpha1
kind: HostnameConfig
auto: "off"
hostname: "{{ .Node.Host }}.blunders.me"
---
apiVersion: v1alpha1
kind: LinkConfig
name: {{ .Node.Data.linkName }}
mtu: 1500
addresses:
  - address: {{ .Node.IP }}/23
routes:
  - gateway: 192.168.6.1
