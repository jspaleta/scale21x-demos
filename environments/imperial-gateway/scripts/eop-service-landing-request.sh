#!/bin/bash
HTTP_INGRESS=$(kubectl get -n eye-of-palpatine svc/eye-of-palpatine -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl --fail-with-body -XPOST http://"$HTTP_INGRESS"/v1/request-landing

