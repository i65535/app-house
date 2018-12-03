#!/bin/bash

f [ -d "/var/local/apphouse" ]; then
  echo "AppHouse installed"
  exit 0 
fi

sudo mkdir data
sudo chown jack:jack data -R
sudo ln -s /opt/apphouse/data/ /var/local/apphouse
sudo chown jack:jack /var/local/apphouse -R
docker run --rm \
  --name apphouse \
  -v /var/local/install:/root/log \
  jack.io/apphouse/install:v1.1.0.15 \
  Install 10.0.0.104 -u jack -p hello2 --offline 1 \
  --domain jack.io

