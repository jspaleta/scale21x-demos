#!/bin/bash
HTTP_INGRESS=$(kubectl get -n eye-of-palpatine svc/eye-of-palpatine -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "# curl --fail-with-body -s http://"$HTTP_INGRESS"/v1/request-landing"
curl --fail-with-body -s -XPOST http://"$HTTP_INGRESS"/v1/request-landing

echo "# curl --fail-with-body -s -H 'x-request-id: alternative' -XPOST http://"$HTTP_INGRESS"/v1/request-landing"
curl --fail-with-body -s -H 'x-request-id: alternative' -XPOST http://"$HTTP_INGRESS"/v1/request-landing

echo "# 10x curl --fail-with-body -s -H 'x-request-id: weighted' -XPOST http://"$HTTP_INGRESS"/v1/request-landing"
for i in {1..10}   # you can also use {0..9}
do
  curl --fail-with-body -s -H 'x-request-id: weighted' -XPOST http://"$HTTP_INGRESS"/v1/request-landing
done


