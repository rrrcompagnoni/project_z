# Geolocation
## Development setup
### Requirements

- Docker version 19.03.13
- docker-compose version 1.27.4

### Building

Before building, you can provide a seed file for seeding the locations.
See the `Dockerfile` instructions.

```
docker-compose build
```

```
docker-compose run geolocation /bin/sh
```

```
mix deps.get && exit
```

### Database setup
```
docker-compose run geolocation mix setup_database
```

### Locations seed
Make sure to follow the `Dockerfile` instructions for the file copying.
```
docker-compose run geolocation iex -S mix

iex(1)> Geolocation.import_locations("data_dump.csv")
```

### Webserver
```
docker-compose up

# Available on http://localhost:4000
```
The Geolocation API blueprint can be found on `geolocation_api.apib`.
