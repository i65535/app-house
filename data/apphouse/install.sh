#! /bin/bash

docker version
if [ $? -ne 0 ];then
    echo "server docker version doesn't match ufleet docker version"
    echo "please install correct docker version "
    exit 1
fi

docker network create apphouse_apphouse

mv ../env.json ./env.json

function config_registry() {
  echo -e "\033[42;37m+ config registry. \033[0m"
  UFLEETIO="127.0.0.1 jack.io"
  cat /etc/hosts | grep ' jack.io$' > /dev/null
  rc=$?
  if [ $rc -eq 0 ];then
    cfg=$(cat /etc/hosts | grep " jack.io$")
    echo ${cfg} | grep "^127.0.0.1 " > /dev/null
    rc=$?
    if [ $rc -ne 0 ];then
      sed -i "s/${cfg}/$(echo ${UFLEETIO} | sed -e 's/\//\\\//g')/g" /etc/hosts
    fi
  else
    sudo echo ${UFLEETIO} >> /etc/hosts
    config_registry_cert
  fi
}

function config_registry_cert() {
  echo -e "\033[42;37m+ config registry cert. \033[0m"
  if [ -f "/etc/pki/tls/certs/ca-bundle.crt" ]; then
    sudo cat ./registry/ca.crt >> /etc/pki/tls/certs/ca-bundle.crt
  elif [ -f "/etc/ssl/certs/ca-certificates.crt" ]; then
    sudo cat ./registry/ca.crt >> /etc/ssl/certs/ca-certificates.crt
  else
    echo -e "\033[42;37m+ config ca certificates fail. \033[0m"
  fi
}

if [ -d "registry" ]; then
  config_registry
  sed -i "s/{REGISTRY_AUTH_ADDRESS}/${HA_NODE_IP}/g" ./registry/config.yml
  mv ./registry ../registry

fi

if [ -d "collector" ]; then
  sed -i "s/REGISTRY_DOMAIN/${REGISTRY_DOMAIN}/g" ./collector/config.conf
  sed -i "s/MONGO_CONNECT_STRING/$(echo ${MONGO_CONNECT_STRING} | sed -e 's/\//\\\//g')/g" ./collector/config.conf
  mv ./collector ../collector
fi

if [ -d "nginxconf" ]; then
  sed -i "s/PrivateRegistryHostIP/${REGISTRY_DOMAIN%:*}/g" `grep PrivateRegistryHostIP ./nginxconf -rl`
  mv ./nginxconf ../nginxconf
fi

mv ./mongodb ../mongodb
mv ./storage ../storage
mv ./ssh ../ssh

exit 0
