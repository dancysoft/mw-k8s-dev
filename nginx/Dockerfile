FROM debian:10

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nginx

COPY nginx-default.conf /etc/nginx/sites-available/default

COPY crt.pem /etc/ssl/certs/www.pem
COPY key.pem /etc/ssl/private/www-key.pem

COPY entrypoint.sh /

EXPOSE 443
ENTRYPOINT ["/entrypoint.sh" ]
