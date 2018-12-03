#!/bin/bash

docker rm -f monitor
docker rm -f ui jenkins gogs registry collector mongodb mysql ntp 
docker network rm apphouse_apphouse
sudo rm -rf /var/local/apphouse
