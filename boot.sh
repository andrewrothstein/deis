#!/usr/bin/env bash
set -x # echo on

make discovery-url
vagrant up
eval `ssh-agent -s`
ssh-add ~/.vagrant.d/insecure_private_key
DEIS_PLATFORM_SSHPRIVATEKEY="~/.ssh/deis"
ssh-add $DEIS_PLATFORM_SSHPRIVATEKEY
ssh-add -l
export DEIS_DOMAIN="local3.deisapp.com"
export DEISCTL_TUNNEL=deis.$DEIS_DOMAIN
deisctl config platform set sshPrivateKey=$DEIS_PLATFORM_SSHPRIVATE_KEY
deisctl config platform set domain=$DEIS_DOMAIN
deisctl install platform
deisctl start platform
deisctl list

# example for registering a user
DEIS_SUPERUSER_NAME="drew"
DEIS_SUPERUSER_PASSWD="deeznuts"
DEIS_SUPERUSER_EMAIL="drew@blackhole.com"
DEIS_SUPERUSER_SSHPUBLIC_KEY="~/.ssh/id_rsa.pub"
deis register http://deis.local3.deisapp.com --username="$DEIS_SUPERUSER_NAME" --password="$DEIS_SUPERUSER_PASSWD" --email="$DEIS_SUPERUSER_EMAIL"
deis keys:add $DEIS_SUPERUSER_SSHPUBLIC_KEY
