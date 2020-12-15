import Config

config :geolocation,
  ecto_repos: [Geolocation.Repo]

config :geolocation, :repo, Geolocation.Repo
config :geolocation, :locations_import_worker, Geolocation.Workers.Locations

import_config "#{Mix.env()}.exs"
