FROM docker-registry.wikimedia.org/wikimedia-buster:latest

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y etcd-server etcd-client ca-certificates

COPY dbconfig.json /tmp

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]

VOLUME /var/lib/etcd
EXPOSE 2379
