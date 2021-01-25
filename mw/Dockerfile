FROM debian:9

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y dirmngr curl sudo
RUN curl -s -f 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xb8a2df05748f9d524a3a2ade9d392d3ffadf18fb' | apt-key add -
RUN echo 'deb [trusted=yes] http://apt.wikimedia.org/wikimedia stretch-wikimedia main' >> /etc/apt/sources.list
RUN echo 'deb [trusted=yes] http://apt.wikimedia.org/wikimedia stretch-wikimedia component/php72' >> /etc/apt/sources.list
RUN apt-get update

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2 php7.2-fpm=7.2.31-1+0~20200514.41+debian9~1.gbpe2a56b+wmf1 php-apcu php-curl php7.2-dba php-intl php-memcached=3.0.1+2.2.0-1~wmf3 php-msgpack=2.0.2+0.5.7-1~wmf3+php72 php-mbstring php-mysql php-redis php-xml apache2 jq libapache2-mod-security2 memcached nginx-full=1.13.9-1+wmf2 rsync scap firejail mysql-client

# Debug stuff
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y strace lsof net-tools tcpdump emacs-nox

COPY php-fpm.conf /etc/php/7.2/fpm/php-fpm.conf

RUN for module in expires headers log_forensic proxy_fcgi proxy rewrite; do a2enmod $module; done
RUN for module in auth_basic authn_file authz_user deflate env negotiation reqtimeout; do a2dismod -f $module; done
RUN for conf in charset javascript-common localized-error-pages other-vhosts-access-log security serve-cgi-bin; do a2disconf $conf; done

COPY apache2/apache2.conf /etc/apache2/apache2.conf
COPY apache2/sites-enabled/ /etc/apache2/sites-enabled/
COPY apache2/sites-available/wikipedia.org.conf /etc/apache2/sites-available/wikipedia.org.conf
COPY apache2/conf-enabled/ /etc/apache2/conf-enabled/
COPY apache2/mods-enabled/ /etc/apache2/mods-enabled/
RUN rm -f /etc/apache2/mods-enabled/status.conf /etc/apache2/sites-enabled/000-default.conf
RUN mkdir -p /var/log/apache2/forensic /run/php

COPY check-and-restart-php restart-php7.2-fpm  /usr/local/sbin/
COPY php7adm /usr/local/bin/php7adm

COPY php-monitoring/ /var/www/php-monitoring/

RUN echo dev > /etc/wikimedia-cluster
RUN useradd mwdeploy -d /var/lib/mwdeploy 

COPY scap.cfg /etc

COPY mediawiki.sh /etc/profile.d/
COPY mwscript /usr/local/bin/

COPY memcached.conf /etc/memcached.conf

COPY entrypoint.sh init-db.sh init-l10n.sh init-l10n-locked.sh /

EXPOSE 80
VOLUME /srv/mediawiki
ENTRYPOINT [ "/entrypoint.sh" ]

RUN curl -L -o /usr/local/sbin/tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-amd64 && chmod +x /usr/local/sbin/tini
