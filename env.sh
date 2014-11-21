#!/usr/bin/env bash
set -x # echo on

export DEIS_DOMAIN="local3.deisapp.com"
export DEISCTL_TUNNEL=deis.$DEIS_DOMAIN
export DEIS_PLATFORM_SSH_PRIVATE_KEY="~/.ssh/deis"
export DEIS_SUPERUSER_NAME="drew"
export DEIS_SUPERUSER_PASSWD="deeznuts"
export DEIS_SUPERUSER_EMAIL="drew@blackhole.com"
export DEIS_SUPERUSER_SSH_PUBLIC_KEY="~/.ssh/id_rsa.pub"