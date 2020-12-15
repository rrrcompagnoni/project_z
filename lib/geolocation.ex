defmodule Geolocation do
  alias Geolocation.Persistence

  require Logger

  @doc """
  Import locations from a source data.

  This function is able to work with:
    - *CSV* source file (provide an absolute path to the *local* file).
  """
  @spec import_locations(String.t(), DateTime.t(), module()) :: atom()
  def import_locations(
        path,
        start_at \\ DateTime.now!("Etc/UTC"),
        worker \\ Geolocation.Workers.Locations
      )
      when is_binary(path) do
    path
    |> worker.import_locations(Path.extname(path))
    |> draw_locations_import_report(start_at)
    |> Logger.info()
  end

  defp draw_locations_import_report(:file_not_supported, _) do
    "The file provided is not supported."
  end

  defp draw_locations_import_report(report, start_at) do
    ~s"""
    Locations import report
    Imported: #{report.accepted}
    Discarded: #{report.discarded}
    Noop: #{report.noop}
    Elapsed time #{DateTime.diff(DateTime.now!("Etc/UTC"), start_at, :second)} seconds.
    """
  end

  @doc """
  Import a single location.
  """
  @spec import_location(%{
          :city => String.t(),
          :country => String.t(),
          :country_code => String.t(),
          :ip_address => String.t(),
          :latitude => String.t(),
          :longitude => String.t(),
          optional(:mystery_value) => String.t()
        }) :: {:ok, Persistence.Location.t()} | {:error, Ecto.Changeset.t()}
  def import_location(attributes) do
    Persistence.insert_location(attributes)
  end

  @doc """
  Count the number of locations available on database.
  """
  @spec count_locations :: integer()
  def count_locations do
    Persistence.count_locations()
  end

  @doc """
  Find a location given an ip address.
  """
  @spec find_location(String.t()) ::
          {:ok, Geolocation.Location.t()} | {:error, :location_not_found}
  def find_location(ip_address)
      when is_binary(ip_address) do
    case repo().get_by(Geolocation.Persistence.Location, ip_address: ip_address) do
      nil ->
        {:error, :location_not_found}

      %Geolocation.Persistence.Location{} = location ->
        {:ok, Geolocation.Location.cast_schema(location)}
    end
  end

  defp repo(), do: Application.get_env(:geolocation, :repo)
end
