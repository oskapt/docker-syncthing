# docker-syncthing 

Run [syncthing](https://syncthing.net) from a docker container. This is targeted for [Rancher](https://www.rancher.com)  and [Gluster](https://git.monach.us/rancher/glusterfs-server), although it could be used elsewhere. 

## Install
```sh
docker pull monachus/syncthing
```

## Environment Variables

* `GLUSTER_HOST` - the hostname for your Gluster server
  * if not provided, it will not mount anything on `/srv/data` before starting syncthing. If you want any sort of persistence, put a volume there.
* `GLUSTER_VOLUME` - the volume from gluster to mount on `/srv/data` (default: `ranchervol`)

## Usage

1. Create a service called `syncthing` in your storage stack that pulls this image
2. Map ports `22000` and `27017/udp` through to the container
3. Set environment variables as defined above.
4. Mount a persistent volume at `/srv/config` for the configuration data.
  * Use [NFS](https://git.monach.us/rancher/nfs-ganesha) with Gluster to make this persistent and flexible
5. (Optional) If not using Gluster, mount a volume on `/srv/data`.
6. Grant the container privileged access.
7. Bind `/dev/fuse` on the host to `/dev/fuse` within the container
8. (Optional) Set a healthcheck on `22000/tcp`
9. Set any labels and schedule it to run on your storage cluster.
10. If you want [iNotify](https://git.monach.us/rancher/syncthing-inotify) support, add that as a sidekick now.

