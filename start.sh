#!/bin/bash

WORKROOT=`PWD`
docker network create apphouse_apphouse
sudo ln -s ${WORKROOT}/data/ /var/local/apphouse
sudo chown jack:jack /var/local/apphouse -R
touch /var/local/apphouse/apphouse/__install__

docker run -d \
  --restart=always \
  --name monitor \
  --net=apphouse_apphouse \
  --log-driver json-file \
  --log-opt max-size=10m \
  -e MODE=Single \
  -e HOST_DOMAIN=10.0.0.104 \
  -e APPHOUSE_DOMAIN=ntp \
  -v /var/run:/var/run \
  -v /var/lib/docker:/var/lib/docker \
  -v /var/local/apphouse/apphouse:/opt/monitor/apphouse \
  -v /var/local/apphouse/monitor:/opt/monitor/trace \
  -p 8880:8880 \
  jack.io/apphouse/monitor:v1.1.0.1
