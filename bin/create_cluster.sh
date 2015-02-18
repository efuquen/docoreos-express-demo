#!/bin/bash

if [[ -z $DO_AUTH ]]; then
  DO_AUTH=$(cat ~/.doauth)
fi

if [[ -z $DISCOVERY_URL ]]; then
  DISCOVERY_URL=$(curl -s https://discovery.etcd.io/new)
fi
echo "Discovery URL: $DISCOVERY_URL"

function json_escape(){
  echo -n "$1" | python -c 'import json,sys; print json.dumps(sys.stdin.read())'
}

function create_cloud_config() {
  cloud_config="#cloud-config

  coreos:
    update:
      reboot-strategy: off
    etcd:
      discovery: ${DISCOVERY_URL}
      addr: \$private_ipv4:4001
      peer-addr: \$private_ipv4:7001
    fleet:
      metadata: region=nyc3,environment=test,role=$1
    units:
      - name: etcd.service
        command: start
      - name: fleet.service
        command: start
  "
  json_cloud_config=$(json_escape "$cloud_config")
  echo "$json_cloud_config"
}

function do_create() {
  cloud_config=$(create_cloud_config $2)
  data='{"name":'"\"$1\""',"region":"nyc3","size":"512mb","image":"coreos-beta","ssh_keys":["691612"],"backups":false,"ipv6":true,"user_data":'"$cloud_config"',"private_networking":true}'

  curl -i -X POST \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $DO_AUTH" \
    -d "$data" \
    "https://api.digitalocean.com/v2/droplets"
}

do_create "dodemo-nyc3-web01.somespider.com" "web"
do_create "dodemo-nyc3-web02.somespider.com" "web"
do_create "dodemo-nyc3-lb1.somespider.com" "lb"
