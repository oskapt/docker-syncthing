#!/bin/bash
# strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

: ${NFS_VOLUME:=ranchervol}}

if [ -n "$NFS_HOST" ]; then
  # we have an NFS host, so let's try to mount it
  mount -t nfs ${NFS_HOST}:/${NFS_VOLUME} /srv/data
  rc=$?
  if [ ! $rc -eq 0 ]; then
    echo "Unable to mount ${NFS_VOLUME} from ${NFS_HOST}."
    sleep 1
    exit $rc
  fi
fi

# if this if the first run, generate a useful config
if [ ! -f /srv/config/config.xml ]; then
  echo "generating config"
  /srv/syncthing/syncthing --generate="/srv/config"
  # don't take the whole volume with the default so that we can add additional folders
  sed -E -e 's!id="default"(.*)path="/root/Sync/"!id="default"\1path="\/srv\/data\/st-default/"!' -i /srv/config/config.xml
  # ensure we can see the web ui outside of the docker container
  sed -e "s/<address>127.0.0.1:8384/<address>0.0.0.0:8080/" -i /srv/config/config.xml
fi

exec /srv/syncthing/syncthing -home=/srv/config

