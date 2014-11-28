#!/usr/bin/env bash
set -x # echo on

make discovery-url
vagrant up
deisctl config platform set sshPrivateKey=$DEIS_PLATFORM_SSH_PRIVATE_KEY
deisctl config platform set domain=$DEIS_DOMAIN
deisctl install platform
deisctl start platform
deisctl list
