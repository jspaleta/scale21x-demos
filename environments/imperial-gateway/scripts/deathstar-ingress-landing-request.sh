#!/bin/bash
HTTP_INGRESS=$(kubectl get -n deathstar ingress/deathstar-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl --fail-with-body -XPOST http://"$HTTP_INGRESS"/v1/request-landing

