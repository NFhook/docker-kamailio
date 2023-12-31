FROM debian:bookworm

LABEL maintainer="Victor Seva <linuxmaniac@torreviejawireless.org>"

# Important! Update this no-op ENV variable when this Dockerfile
# is updated with the current date. It will force refresh of all
# of the base images and things like 'apt-get update' won't be using
# old cached versions when the Dockerfile is built.
ENV REFRESHED_AT=2023-11-15 \
    TZ=Asia/Shanghai

RUN rm -rf /var/lib/apt/lists/* && apt-get update &&   DEBIAN_FRONTEND=noninteractive apt-get install -qq --assume-yes gnupg wget
# kamailio repo
RUN echo "deb http://deb.kamailio.org/kamailio57 bookworm main" >   /etc/apt/sources.list.d/kamailio.list
RUN wget -O /tmp/kamailiodebkey.gpg http://deb.kamailio.org/kamailiodebkey.gpg &&   gpg --output /etc/apt/trusted.gpg.d/deb-kamailio-org.gpg --dearmor /tmp/kamailiodebkey.gpg
RUN apt-get update &&   DEBIAN_FRONTEND=noninteractive apt-get install -qq --assume-yes kamailio=5.7.2+bpo12 kamailio-autheph-modules=5.7.2+bpo12 kamailio-berkeley-bin=5.7.2+bpo12 kamailio-berkeley-modules=5.7.2+bpo12 kamailio-cnxcc-modules=5.7.2+bpo12 kamailio-cpl-modules=5.7.2+bpo12 kamailio-dbg=5.7.2+bpo12 kamailio-erlang-modules=5.7.2+bpo12 kamailio-extra-modules=5.7.2+bpo12 kamailio-geoip-modules=5.7.2+bpo12 kamailio-geoip2-modules=5.7.2+bpo12 kamailio-ims-modules=5.7.2+bpo12 kamailio-json-modules=5.7.2+bpo12 kamailio-kazoo-modules=5.7.2+bpo12 kamailio-ldap-modules=5.7.2+bpo12 kamailio-lua-modules=5.7.2+bpo12 kamailio-lwsc-modules=5.7.2+bpo12 kamailio-memcached-modules=5.7.2+bpo12 kamailio-mongodb-modules=5.7.2+bpo12 kamailio-mono-modules=5.7.2+bpo12 kamailio-mqtt-modules=5.7.2+bpo12 kamailio-mysql-modules=5.7.2+bpo12 kamailio-nats-modules=5.7.2+bpo12 kamailio-nth=5.7.2+bpo12 kamailio-outbound-modules=5.7.2+bpo12 kamailio-perl-modules=5.7.2+bpo12 kamailio-phonenum-modules=5.7.2+bpo12 kamailio-postgres-modules=5.7.2+bpo12 kamailio-presence-modules=5.7.2+bpo12 kamailio-python3-modules=5.7.2+bpo12 kamailio-rabbitmq-modules=5.7.2+bpo12 kamailio-radius-modules=5.7.2+bpo12 kamailio-redis-modules=5.7.2+bpo12 kamailio-ruby-modules=5.7.2+bpo12 kamailio-sctp-modules=5.7.2+bpo12 kamailio-secsipid-modules=5.7.2+bpo12 kamailio-snmpstats-modules=5.7.2+bpo12 kamailio-sqlite-modules=5.7.2+bpo12 kamailio-systemd-modules=5.7.2+bpo12 kamailio-tls-modules=5.7.2+bpo12 kamailio-unixodbc-modules=5.7.2+bpo12 kamailio-utils-modules=5.7.2+bpo12 kamailio-websocket-modules=5.7.2+bpo12 kamailio-xml-modules=5.7.2+bpo12 kamailio-xmpp-modules=5.7.2+bpo12 kamcli

VOLUME /etc/kamailio

# clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# set SHM_MEMORY and PKG_MEMORY from ENV
ENV SHM_MEMORY=256
ENV PKG_MEMORY=64

HEALTHCHECK --interval=15s --timeout=5s \
    CMD kamcmd core.uptime | grep -q "uptime:" || exit 1
ENTRYPOINT kamailio -DD -E -m ${SHM_MEMORY} -M ${PKG_MEMORY}
