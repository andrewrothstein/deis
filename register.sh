#!/usr/bin/env/ bash

# example for registering a user
deis register $DEIS_CONTROLLER \
     --username="$DEIS_SUPERUSER_NAME" \
     --password="$DEIS_SUPERUSER_PASSWD" \
     --email="$DEIS_SUPERUSER_EMAIL"

deis keys:add $DEIS_SUPERUSER_SSH_PUBLIC_KEY
