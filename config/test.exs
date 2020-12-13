import Mix.Config

config :geolocation, Geolocation.Repo,
  username: "postgres",
  password: "postgres",
  database: "geolocation_repo_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

config :geolocation,
  http_port: 4001

config :plug, :validate_header_keys_during_test, true
