import Config

config :geolocation,
  ecto_repos: [Geolocation.Repo]

config :geolocation, :repo, Geolocation.Repo

import_config "#{Mix.env()}.exs"

