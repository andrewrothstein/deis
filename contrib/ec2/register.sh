#!/usr/bin/env bash
set -x # echo on

source env.sh
make discovery-url
vagrant up
source ssh-env.sh
deisctl config platform set sshPrivateKey=$DEIS_PLATFORM_SSH_PRIVATE_KEY
deisctl config platform set domain=$DEIS_DOMAIN
deisctl install platform
deisctl start platform
deisctl list

# example for registering a user
deis register http://deis.local3.deisapp.com --username="$DEIS_SUPERUSER_NAME" --password="$DEIS_SUPERUSER_PASSWD" --email="$DEIS_SUPERUSER_EMAIL"
deis keys:add $DEIS_SUPERUSER_SSH_PUBLIC_KEY
