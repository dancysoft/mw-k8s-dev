FROM docker-registry.wikimedia.org/wikimedia-buster:latest

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server python3-mysqldb tini

COPY 99-server-bind-wildcard.cnf /etc/mysql/mariadb.conf.d/99-server-bind-wildcard.cnf
COPY 99-mediawiki.cnf /etc/mysql/mariadb.conf.d/99-mediawiki.cnf

# Debug stuff
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y strace lsof procps

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# VOLUME for data directory
EXPOSE 3306


