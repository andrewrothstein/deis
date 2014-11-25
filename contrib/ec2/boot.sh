#!/usr/bin/env bash
set -x # echo on

make discovery-url
source ssh-env.sh
source provision-ec2-cluster.sh
deisctl config platform set sshPrivateKey=$DEIS_PLATFORM_SSH_PRIVATE_KEY
deisctl config platform set domain=$DEIS_DOMAIN
deisctl install platform
deisctl start platform
deisctl list

# example for registering a user
deis register $DEIS_CONTROLLER_URL --username="$DEIS_SUPERUSER_NAME" --password="$DEIS_SUPERUSER_PASSWD" --email="$DEIS_SUPERUSER_EMAIL"
deis keys:add $DEIS_SUPERUSER_SSH_PUBLIC_KEY
