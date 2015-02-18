#!/bin/bash

if [[ -z $DOCKER_IMAGE ]]; then
  DOCKER_IMAGE="quay.io/efuquen/docoreos-express-demo"
fi

if [[ -z $DO_AUTH ]]; then
  DO_AUTH=$(cat ~/.doauth)
fi

if [[ -z $DO_IP ]]; then 
  DO_IP=$(curl -s -X GET -H 'Content-Type: application/json' -H "Authorization: Bearer $DO_AUTH" "https://api.digitalocean.com/v2/droplets?page=1&per_page=1" | python -m json.tool | grep ip_address | head -n 2 | tail -n 1 | awk -F '"' '{ print $4 }')
fi

docker push $DOCKER_IMAGE
echo "IP: $DO_IP"
scp ./units/docoreos-express-demo@.service core@$DO_IP:~/
scp ./units/registrator@.service core@$DO_IP:~/
scp ./units/haproxy@.service core@$DO_IP:~/

ssh core@$DO_IP fleetctl start registrator@1.service
ssh core@$DO_IP fleetctl start registrator@2.service

ssh core@$DO_IP fleetctl start docoreos-express-demo@1.service
ssh core@$DO_IP fleetctl start docoreos-express-demo@2.service

ssh core@$DO_IP fleetctl start haproxy@1.service
