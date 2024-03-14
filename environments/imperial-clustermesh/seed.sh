#!/bin/bash
kubectl create ns backend --dry-run -o yaml \
  | linkerd inject - \
  | kubectl apply -f -

kubectl create ns frontend --dry-run -o yaml \
  | linkerd inject - \
  | kubectl apply -f -

kubectl create ns deathstar --dry-run -o yaml \
  | linkerd inject - \
  | kubectl apply -f -
kubectl create ns eye-of-palpatine --dry-run -o yaml \
  | linkerd inject - \
  | kubectl apply -f -
kubectl create ns infra --dry-run -o yaml \
  | linkerd inject - \
  | kubectl apply -f -

kubectl apply -f k8s/empire.yaml

helm repo add podinfo https://stefanprodan.github.io/podinfo
helm install backend-a -n backend \
  --set ui.message='A backend' podinfo/podinfo
helm install backend-b -n backend \
  --set ui.message='B backend' podinfo/podinfo
helm install frontend -n frontend \
  --set backend=http://backend-a-podinfo.backend:9898/env podinfo/podinfo
helm install frontend -n backend \
  --set backend=http://backend-a-podinfo.backend:9898/env podinfo/podinfo

kubectl patch svc frontend-podinfo -n frontend -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc frontend-podinfo -n backend  -p '{"spec": {"type": "LoadBalancer"}}'

