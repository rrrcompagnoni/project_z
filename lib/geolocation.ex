defmodule Geolocation do
  require Logger

  alias Geolocation.Schemas

  @doc """
  Import locations from a source data.

  This function is able to work with:
    - *CSV* source file (provide an absolute path to the *local* file).
  """
  @spec import_locations(String.t(), DateTime.t()) :: atom()
  def import_locations(
        path,
        start_at \\ DateTime.now!("Etc/UTC")
      )
      when is_binary(path) do
    path
    |> locations_import_worker().import_locations(Path.extname(path))
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
  Insert locations into the database in one pass.

  It assumes all locations given are
  from a reliable source of data. Any invalid location
  will rollback the database transaction.
  The `Geolocation.valid_location_attributes?/1` helps you
  to validate your attributes.
  """
  @spec bulk_insert_locations(list(map())) :: {:ok, {integer(), nil | [term()]}}
  def bulk_insert_locations(locations) do
    Geolocation.Repo.transaction(fn ->
      Geolocation.Repo.insert_all(Schemas.Location, locations, on_conflict: :nothing)
    end)
  end

  @doc """
  Checks whether location attributes are valid or invalid.
  """
  @spec valid_location_attributes?(map()) :: true | false
  def valid_location_attributes?(attributes) do
    Schemas.Location.changeset(%Schemas.Location{}, attributes).valid?
  end

  @doc """
  Find a location given an ip address.
  """
  @spec find_location(String.t()) ::
          {:ok, Geolocation.Location.t()} | {:error, :location_not_found}
  def find_location(ip_address)
      when is_binary(ip_address) do
    case repo().get_by(Schemas.Location, ip_address: ip_address) do
      nil ->
        {:error, :location_not_found}

      %Schemas.Location{} = location ->
        {:ok, Geolocation.Location.cast_schema(location)}
    end
  end

  defp repo(), do: Application.get_env(:geolocation, :repo)
  defp locations_import_worker(), do: Application.get_env(:geolocation, :locations_import_worker)
end
