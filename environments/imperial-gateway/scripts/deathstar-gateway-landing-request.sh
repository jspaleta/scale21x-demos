#!/bin/bash
#GATEWAY=$(kubectl get -n deathstar gateway/deathstar-gateway -o jsonpath='{.status.addresses[0].value}')
GATEWAY="www.deathstar.empire"
echo "# curl --fail-with-body -XPOST http://"$GATEWAY"/v1/request-landing"
curl --fail-with-body -XPOST http://"$GATEWAY"/v1/request-landing

echo "# curl --fail-with-body -XPOST -H 'x-request-id: alternative' http://"$GATEWAY"/v1/request-landing"
curl --fail-with-body -XPOST -H 'x-request-id: alternative' http://"$GATEWAY"/v1/request-landing

echo "# 10x curl --fail-with-body -XPOST -H 'x-request-id: weighted' http://"$GATEWAY"/v1/request-landing"
for i in {1..10}   # you can also use {0..9}
do
  curl --fail-with-body -XPOST -H 'x-request-id: weighted' http://"$GATEWAY"/v1/request-landing
done
