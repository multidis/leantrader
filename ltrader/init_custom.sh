#!/bin/bash

# custom logic preceding LEAN launch
### e.g. get snapshot from S3 in case this is instance restart


# Alpaca trading mode and credentials
sed -i 's/\"alpaca-trading-mode\"\:\s\".*\"/"alpaca-trading-mode": "'"${ALPACA_MODE}"'"/' /home/leanu/Lean-master/Launcher/config.json
sed -i 's/\"alpaca-key-id\"\:\s\"\"/"alpaca-key-id": "'"${ALPACA_ID}"'"/' /home/leanu/Lean-master/Launcher/config.json
# IMPORTANT: escape special characters when assigning env vars passed to the container!
sed -i 's/\"alpaca-secret-key\"\:\s\"\"/"alpaca-secret-key": "'"${ALPACA_KEY}"'"/' /home/leanu/Lean-master/Launcher/config.json

# rebuild the algorithm with the updated config.json
cd /home/leanu/Lean-master
msbuild /property:Configuration=Release /home/leanu/Lean-master/Launcher/QuantConnect.Lean.Launcher.csproj
cd /home/leanu/Lean-master/Launcher/bin/Release

