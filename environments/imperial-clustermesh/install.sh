#!/bin/bash
### Infrascture Admin: provisions the cluster so it supports ingress/gateway-api
kind create cluster --config kind/kind-config.yaml

docker pull ghcr.io/kube-vip/kube-vip-cloud-provider:v0.0.9
docker pull ghcr.io/kube-vip/kube-vip:v0.5.7

kind load docker-image ghcr.io/kube-vip/kube-vip-cloud-provider:v0.0.9 -n imperial-clustermesh
kind load docker-image ghcr.io/kube-vip/kube-vip:v0.5.7 -n imperial-clustermesh
kind load docker-image local/starwars:0.1 -n imperial-clustermesh
kind load docker-image cr.l5d.io/linkerd/policy-controller:edge-24.3.2 -n imperial-clustermesh   
kind load docker-image cr.l5d.io/linkerd/controller:edge-24.3.2 -n imperial-clustermesh
kind load docker-image cr.l5d.io/linkerd/proxy:edge-24.3.2 -n imperial-clustermesh
kind load docker-image cr.l5d.io/linkerd/proxy-init:v2.2.4 -n imperial-clustermesh
kind load docker-image ghcr.io/stefanprodan/podinfo:6.6.0 -n imperial-clustermesh

kubectl apply -f k8s/kube-vip/kube-vip-rbac.yaml
kubectl create configmap --namespace kube-system kubevip --from-literal range-global=172.18.210.100-172.18.210.200
kubectl apply -f k8s/kube-vip/kube-vip-cloud-controller.yaml
docker run --network host --rm ghcr.io/kube-vip/kube-vip:v0.5.7 manifest daemonset --services --inCluster --arp --interface eth0 | kubectl apply -f -

#helm install cilium cilium/cilium -n kube-system --version $CILIUM_VERSION -f ./helm-values-ingress.yaml
#cilium install --version $CILIUM_VERSION -f ./helm-values-ingress.yaml
#cilium status --wait

linkerd check --pre
linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -
linkerd check

