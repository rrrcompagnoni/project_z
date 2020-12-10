import Mix.Config

config :geolocation, Geolocation.Repo,
  username: "postgres",
  password: "postgres",
  database: "geolocation_repo_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox
