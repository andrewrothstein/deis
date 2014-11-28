#!/usr/bin/env sh
# example for registering a user
deis login $DEIS_CONTROLLER_URL \
     --username="$DEIS_SUPERUSER_NAME" \
     --password="$DEIS_SUPERUSER_PASSWD"

