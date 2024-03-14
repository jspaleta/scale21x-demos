#!/bin/bash
GATEWAY=$(kubectl get -n deathstar gateway/deathstar-gateway -o jsonpath='{.status.addresses[0].value}')
echo $GATEWAY
curl --fail-with-body -XPUT http://"$GATEWAY"/v1/exhaust-port

