import Mix.Config

config :geolocation, Geolocation.Repo,
  username: "postgres",
  password: "postgres",
  database: "geolocation_repo_dev",
  hostname: "db"
