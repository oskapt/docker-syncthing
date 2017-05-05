#!/bin/bash
# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# if this if the first run, generate a useful config
if [ ! -f /srv/config/config.xml ]; then
  echo "generating config"
  /srv/syncthing/syncthing --generate="/srv/config"
  # don't take the whole volume with the default so that we can add additional folders
  sed -E -e 's!id="default"(.*)path="/root/Sync/"!id="default"\1path="\/srv\/data\/st-default/"!' -i /srv/config/config.xml
  # ensure we can see the web ui outside of the docker container
  sed -e "s/<address>127.0.0.1:8384/<address>0.0.0.0:8080/" -i /srv/config/config.xml
fi

# no auto upgrades
sed -Ee "s!<autoUpgradeIntervalH>[[:digit:]]+!<autoUpgradeIntervalH>0!" -i /srv/config/config.xml

exec /srv/syncthing/syncthing -home=/srv/config

