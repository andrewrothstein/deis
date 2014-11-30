#!/usr/bin/env bash
set -x # echo on

make discovery-url
vagrant up
deisctl config platform set sshPrivateKey=$DEIS_PLATFORM_SSH_PRIVATE_KEY
sleep 1
deisctl config platform set domain=$DEIS_DOMAIN
sleep 1
deisctl install platform
deisctl start platform
deisctl list
