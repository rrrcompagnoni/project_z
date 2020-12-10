FROM elixir:1.11.2-alpine

RUN apk update

RUN mkdir /opt/geolocation

WORKDIR /opt/geolocation

COPY lib .
COPY test .
COPY mix.exs .
COPY mix.lock .

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get
