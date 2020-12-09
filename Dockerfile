FROM elixir:1.11.2-alpine

RUN apk update

RUN mkdir /opt/geolocation

WORKDIR /opt/geolocation
