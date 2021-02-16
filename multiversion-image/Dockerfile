FROM debian:10
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y jq git
ARG GERRITMIRROR
COPY build /
RUN /build

