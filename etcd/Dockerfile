FROM debian:10

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y etcd-server etcd-client ca-certificates

COPY dbconfig.json /tmp

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]

VOLUME /var/lib/etcd
EXPOSE 2379
