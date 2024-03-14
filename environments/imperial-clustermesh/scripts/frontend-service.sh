#!/bin/bash
HTTP_INGRESS=$(kubectl get -n frontend svc/frontend-podinfo -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
#HTTP_INGRESS='localhost'

echo "# curl --fail-with-body -s -XPUT http://"$HTTP_INGRESS":9898/echo"
curl --fail-with-body -s -XPUT http://"$HTTP_INGRESS":9898/echo | grep -o 'PODINFO_UI_MESSAGE=. backend'

echo "# curl --fail-with-body -s -XPUT -H 'x-request-id: alternative' http://"$HTTP_INGRESS":9898/echo"
curl --fail-with-body -sX POST -H 'x-request-id: alternative' http://"$HTTP_INGRESS":9898/echo | grep -o 'PODINFO_UI_MESSAGE=. backend'

echo "# 10x curl --fail-with-body -s -XPUT -H 'x-request-id: weighted' http://"$HTTP_INGRESS":9898/echo"
for i in {1..10}   # you can also use {0..9}
do
  curl --fail-with-body -sX POST -H 'x-request-id: weighted' http://"$HTTP_INGRESS":9898/echo | grep -o 'PODINFO_UI_MESSAGE=. backend'
done

