#!/bin/bash

# custom logic before restart
### e.g. verify snapshot is ready to pick up algo state after a crash


# LEAN process to keep restarting
/home/leanu/notify_aws_sns.sh "LEAN process restarted." \
  "$([ -f /var/log/leanrun.log ] && tail /var/log/leanrun.log -n 30)" \
  "$([ -f /home/leanu/Lean-master/Launcher/bin/Release/LTraderAlgorithm-log.txt ] && tail /home/leanu/Lean-master/Launcher/bin/Release/LTraderAlgorithm-log.txt)"
mono /home/leanu/Lean-master/Launcher/bin/Release/QuantConnect.Lean.Launcher.exe

# pause in case LEAN keeps exiting due to some severe exception
# (i.e. prevent too frequent restarts)
sleep 180

