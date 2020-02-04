#!/bin/bash

## Pass command-live variables: Alpaca mode, key id, secret;
## example:
## ./utils/docker_build_run_local.sh "paper" "idhere" "key/here"

ALPACA_MODE="$1"
ALPACA_ID="$2"
# escape special characters
ALPACA_KEY="$(printf '%s\n' "$3" | sed 's:[][\/.^$*]:\\&:g')"

docker build -t ltrader:latest --rm .

docker run --env ALPACA_MODE=${ALPACA_MODE} \
   --env ALPACA_ID=${ALPACA_ID} \
   --env ALPACA_KEY=${ALPACA_KEY} \
   --rm -t -i ltrader:latest /sbin/my_init -- bash -l

