import Config

import_config "#{Mix.env()}.exs"

config :geolocation,
  ecto_repos: [Geolocation.Repo]
