FROM elixir:1.11.2-alpine

RUN apk update

RUN mkdir /opt/geolocation

WORKDIR /opt/geolocation

COPY lib .
COPY test .
COPY mix.exs .
COPY mix.lock .

# To help the seeding of the development database
# copy the data_dump file to the project
# root path and uncomment the next line.
# COPY data_dump.csv .

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get
