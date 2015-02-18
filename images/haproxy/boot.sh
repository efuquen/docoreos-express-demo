#!/bin/bash

service rsyslog start
service haproxy start

until confd -onetime -node $COREOS_PRIVATE_IPV4:4001 -config-file /etc/confd/conf.d/haproxy.toml; do
  echo "[haproxy] waiting for confd to refresh haproxy.conf"
  sleep 5
done

confd -interval 10 -node $COREOS_PRIVATE_IPV4:4001 -config-file /etc/confd/conf.d/haproxy.toml
