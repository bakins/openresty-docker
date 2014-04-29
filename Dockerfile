FROM ubuntu:12.04

ENV DEBIAN_FRONTEND noninteractive

ENV VERSION 1.4.3.6
ENV LUAROCKS_VERSION 2.1.2

ADD build.sh /tmp/

RUN bash /tmp/build.sh

