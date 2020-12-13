defmodule Geolocation.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Geolocation.Repo, []},
      {Geolocation.LifeCycle.LocationsImportSupervisor, nil},
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: GeolocationWeb.Endpoint,
        options: [port: Application.get_env(:geolocation, :http_port)]
      )
    ]

    opts = [strategy: :one_for_one, name: Geolocation.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
