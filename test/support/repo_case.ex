defmodule Geolocation.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Geolocation.Repo

      import Ecto
      import Ecto.Query
      import Geolocation.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Geolocation.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Geolocation.Repo, {:shared, self()})
    end

    :ok
  end
end
