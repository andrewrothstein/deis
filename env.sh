#!/usr/bin/env bash
<<<<<<< HEAD
export DEIS_DOMAIN="deis.dev"
export DEISCTL_TUNNEL="deis.dev"
export FLEETCTL_TUNNEL=$DEISCTL_TUNNEL
export DEIS_CONTROLLER_URL="http://deis.dev"
=======
export DEIS_DOMAIN="local3.deisapp.com"
export DEISCTL_TUNNEL=deis.$DEIS_DOMAIN
export FLEETCTL_TUNNEL=$DEISCTL_TUNNEL
>>>>>>> origin/master
export DEIS_PLATFORM_SSH_PRIVATE_KEY=~/.ssh/deis
export DEIS_SUPERUSER_NAME="drew"
export DEIS_SUPERUSER_PASSWD="deezNut$"
export DEIS_SUPERUSER_EMAIL="drew@blackhole.com"
export DEIS_SUPERUSER_SSH_PUBLIC_KEY=~/.ssh/id_rsa.pub
