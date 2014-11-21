#!/usr/bin/env bash
source env.sh
eval `ssh-agent -s`
ssh-add ~/.vagrant.d/insecure_private_key
ssh-add $DEIS_PLATFORM_SSH_PRIVATE_KEY
ssh-add -l
