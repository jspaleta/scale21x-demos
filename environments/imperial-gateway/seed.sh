#!/bin/bash
### Teams control each of their own namespaces
kubectl apply -f k8s/empire.yaml

### Cluster Operator controls setting up the ingress or gateway-api
kubectl apply -f k8s/deathstar-ingress.yaml
kubectl apply -f k8s/deathstar-gateway.yaml
kubectl apply -f k8s/eye-of-palpatine-ingress.yaml
kubectl apply -f k8s/simple-infra-gateway.yaml
echo 
echo "################################################"
echo "Waiting for cluster to be ready for gateway demo"
echo "################################################"
sleep 10
echo "Ingresses:" 
kubectl get ingress -A
echo "Gateways:" 
kubectl get gateway -A
echo "LoadBalancer services:" 
kubectl get svc -A |grep LoadBalancer
echo ""
echo "Checking Infra Gateway Setup"
echo "Infra gateway:"
kubectl get gateway -A |grep infra
echo "DNS names:"
grep infra /etc/hosts
### Teams controls the gateway routes

### RefGrants allow teems to collaborate without cluster operator intervention

