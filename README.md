# docker-syncthing

Run [syncthing](https://syncthing.net) within a docker container.

## Install
```sh
docker pull monachus/syncthing
```

## Persistent Storage

### Data

Mount a volume on `/srv/data`.

### Config

Mount a volume on `/srv/config`.

## Ports

You'll need the following ports open:

- `8080/tcp` - web interface
- `22000/tcp` - sync
- `21027/udp` - discovery
