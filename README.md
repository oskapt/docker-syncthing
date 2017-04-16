# docker-syncthing 

Run [syncthing](https://syncthing.net) from a docker container. This is targeted for [Rancher](https://www.rancher.com), although it could be used elsewhere. 

## Install
```sh
docker pull monachus/syncthing
```

## Usage

1. Create a service called `syncthing` in your storage stack that pulls this image
2. Map ports `22000` and `27017/udp` through to the container
3. Create a `config` sidekick and mount a persistent volume at `/srv/config` for the configuration data.
4. Add any data volumes you wish to replicate (such as volumes from Rancher NFS) and mount all volumes from `config`
  * Mount the data volumes beneath `/srv/data`
5. Grant the container privileged access.
6. Bind `/dev/fuse` on the host to `/dev/fuse` within the container
7. (Optional) Set a healthcheck on `22000/tcp`
8. Set any labels and schedule it to run on your storage cluster.

