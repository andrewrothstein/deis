#!/usr/bin/env sh

make discovery-url
vagrant up
eval `ssh-agent -s`
ssh-add ~/.vagrant.d/insecure_private_key
ssh-add ~/.ssh/deis
ssh-add -l
export DEISCTL_TUNNEL=deis.local3.deisapp.com
deisctl config platform set sshPrivateKey=~/.ssh/deis
deisctl config platform set domain=local3.deisapp.com
deisctl install platform
deisctl start platform
deisctl list

# example for registering a user
DEIS_SUPERUSER_NAME="drew"
DEIS_SUPERUSER_PASSWD="deeznuts"
DEIS_SUPERUSER_EMAIL="drew@blackhole.com"
deis register http://deis.local3.deisapp.com --username="$DEIS_SUPERUSER_NAME" --password="$DEIS_SUPERUSER_PASSWD" --email="$DEIS_SUPERUSER_EMAIL"



