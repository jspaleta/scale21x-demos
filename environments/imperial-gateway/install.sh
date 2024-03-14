#!/bin/bash
CILIUM_VERSION="${CILIUM_VERSION:-v1.15.1}"
### https://github.com/thebsdbox/cilium-grafana-observability-demo/tree/main


### Infrascture Admin: provisions the cluster so it supports ingress/gateway-api
kind create cluster --config ./kind/kind-config.yaml
ret=$?
if [ $ret -ne 0 ]
then
    kubectl config use-context kind-imperial-gateway
fi

CDIR=$(pwd)
cd ../../starwars-docker/
IMAGE=local/starwars:0.1 make build
cd $CDIR

docker pull quay.io/cilium/cilium:${CILIUM_VERSION}
docker pull quay.io/cilium/operator-generic:${CILIUM_VERSION}

kind load docker-image local/starwars:0.1 -n imperial-gateway
kind load docker-image quay.io/cilium/cilium:${CILIUM_VERSION} -n imperial-gateway
kind load docker-image quay.io/cilium/operator-generic:${CILIUM_VERSION} -n imperial-gateway

kubectl apply -f k8s/kube-vip-rbac.yaml
kubectl create configmap --namespace kube-system kubevip --from-literal range-global=172.18.200.100-172.18.200.200
kubectl apply -f k8s/kube-vip-cloud-controller.yaml
docker run --network host --rm ghcr.io/kube-vip/kube-vip:v0.5.7 manifest daemonset --services --inCluster --arp --interface eth0 | kubectl apply -f -

kubectl apply -f k8s/gateway-api/gateway.networking.k8s.io_gatewayclasses.yaml
kubectl apply -f k8s/gateway-api/gateway.networking.k8s.io_gateways.yaml
kubectl apply -f k8s/gateway-api/gateway.networking.k8s.io_grpcroutes.yaml
kubectl apply -f k8s/gateway-api/gateway.networking.k8s.io_httproutes.yaml
kubectl apply -f k8s/gateway-api/gateway.networking.k8s.io_referencegrants.yaml
kubectl apply -f k8s/gateway-api/gateway.networking.k8s.io_tlsroutes.yaml



cilium install --version $CILIUM_VERSION -f ./cilium/helm-values-ingress.yaml 
