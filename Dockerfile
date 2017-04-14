# ubuntu 15 saves about 50MB over ubuntu stable
FROM ubuntu:15.10

RUN apt-get -qq update \
  && apt-get -qq install curl ca-certificates -y --no-install-recommends \
  && apt-get -qq autoremove -y \
  && apt-get -qq clean

# get dumb-init
ENV DI_VERSION 1.2.0
RUN cd /tmp && \
    curl -sL -o /bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DI_VERSION}/dumb-init_${DI_VERSION}_amd64 && \
    chmod +x /bin/dumb-init

# get syncthing
ENV SYNCTHING_VERSION 0.14.26
WORKDIR /srv
RUN useradd --no-create-home -g users syncthing
RUN curl -sS -L -o syncthing.tar.gz https://github.com/syncthing/syncthing/releases/download/v$SYNCTHING_VERSION/syncthing-linux-amd64-v$SYNCTHING_VERSION.tar.gz \
  && tar -xzf syncthing.tar.gz \
  && rm -f syncthing.tar.gz \
  && mv syncthing-linux-amd64-v* syncthing \
  && rm -rf syncthing/etc \
  && rm -rf syncthing/*.pdf \
  && mkdir -p /srv/config \
  && mkdir -p /srv/data

VOLUME ["/srv/data", "/srv/config"]

ADD ./start.sh /start.sh
RUN chmod 770 /start.sh

ENTRYPOINT ["dumb-init", "--"]
CMD ["/start.sh"]

