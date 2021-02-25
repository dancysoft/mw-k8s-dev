FROM docker-registry.wikimedia.org/wikimedia-buster:latest
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y jq git ca-certificates
ARG GERRITMIRROR
COPY build /
RUN /build

