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

# register user drew
source register.sh
