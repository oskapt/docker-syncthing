Run [syncthing](https://syncthing.net) from a docker container. This is targeted for [Rancher](https://www.rancher.com), although it could be used elsewhere. 

## Objective

Solutions for distributed storage within Docker are not yet within the reach of the common man. Normal people don't have access to EMC towers or enough hosts to run a solution like Portworx. What if all you want is a way to be sure that your data exists in multiple locations? 

I wanted a simple solution that allowed me to do replication of files between Rancher nodes in AWS, or between my Mac, my wife's Mac, and a Rancher server/node running on a Mac Mini in my home's network closet. Syncthing gives me all of that, with full control over my data. 

Rancher makes it easy to manage.

## Variables

The container sets sane defaults, but it recognizes run-time environment variables as follows:

- `LISTEN_PORT` - The port to run the UI on (8080)

## Install
```sh
docker pull monachus/syncthing
```

## Usage With Rancher

1. Create a service called `syncthing` in your stack that pulls this image. I use a dedicated `storage` stack for the service.
2. Map ports `22000` and `21027/udp` through from the host to the container
3. Create a `config` sidekick and mount a persistent volume at `/srv/config` for the configuration data.
  - If operating out in a cloud environment, use some type of cloud storage. If operating in a home environment, this could be a local Docker volume or also an NFS share. 
  - If using the same storage type for both `config` and `data`, you don't need to use a data container.
4. Add any data volumes you wish to replicate (such as volumes from Rancher NFS) and mount all volumes from `config`
  - Mount the data volumes beneath `/srv/data`
5. (Optional) Set a TCP healthcheck on `22000/tcp`
6. Set any labels and schedule it to run on your storage cluster.
7. Add it to your frontend load balancer, connecting your chosen hostname to port 8080 in the service.
8. After it starts up, connect to it, configure passwords, and start setting up your synced folders.

## Usage Without Rancher

1. Use a `docker-compose.yml` file like the one below to start the service.
```yaml
version: '2'
volumes:
  syncthing-conf:
    driver: local
  syncthing-data:
    driver: local
services:
  syncthing:
    image: monachus/syncthing:0.14.36
    hostname: server
    volumes:
    - syncthing-data:/srv/data
    - syncthing-conf:/srv/config
    ports:
    - 22000:22000/tcp
    - 21027:21027/udp
    - 8080:8080/tcp
```
