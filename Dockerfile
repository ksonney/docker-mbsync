FROM golang:alpine3.20 AS build
RUN apk add --no-cache shellcheck

RUN mkdir /overlay
COPY root/ /overlay/
RUN find /overlay -type f | xargs shellcheck -e SC1008


FROM two70/s6-alpine:latest
LABEL maintainer="Kevin Sonney <kevin@sonney.com>"

ENV \
    # Fail if cont-init scripts exit with non-zero code.
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    CRON="" \
    HEALTHCHECK_ID="" \
    HEALTHCHECK_HOST="https://hc-ping.com" \
    PUID="" \
    PGID=""

RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community > /etc/apk/repositories \
 && echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
 && echo @edge http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN apk add --no-cache \
      isync@edge \
      curl@edge \
      cyrus-sasl@edge \
      cyrus-sasl-xoauth2@edge \
 && rm -rf /var/cache/* \
 && mkdir /var/cache/apk

COPY root/ /
