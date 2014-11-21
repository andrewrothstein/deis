#!/usr/bin/env sh
make discovery-url
vagrant up
eval `ssh-agent -s`
ssh-add ~/.vagrant.d/insecure_private_key
ssh-add ~/.ssh/deis
ssh-add -l
export DEISCTL_TUNNEL=localhost:2222
deisctl config platform set sshPrivateKey=~/.ssh/deis
deisctl config platform set domain=local3.deisapp.com
deisctl install platform
deisctl start platform
deisctl list
deis register deis.local3.deisapp.com
