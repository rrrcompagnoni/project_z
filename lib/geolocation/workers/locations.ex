defmodule Geolocation.Workers.Locations do
  alias Geolocation.LifeCycle.LocationsTaskSupervisor
  alias Geolocation.Machinery.LocationsImportReport
  alias Geolocation.Persistence

  NimbleCSV.define(CSVLocationsParser, separator: ",")

  def import_locations(path, ".csv") when is_binary(path) do
    Task.Supervisor.async_stream(
      LocationsTaskSupervisor,
      CSVLocationsParser.parse_stream(File.stream!(path, read_ahead: 5_000)),
      fn
        [
          ip_address,
          country_code,
          country,
          city,
          latitude,
          longitude,
          mystery_value
        ] ->
          attributes = %{
            ip_address: ip_address,
            country_code: country_code,
            country: country,
            city: city,
            latitude: latitude,
            longitude: longitude,
            mystery_value: mystery_value
          }

          {Persistence.valid_location_attributes?(attributes), attributes}
      end
    )
    |> Stream.flat_map(fn
      {:ok, {true, attributes}} ->
        [attributes]

      {:ok, {false, _}} ->
        LocationsImportReport.report_discarded()
        []
    end)
    |> Stream.chunk_every(5_000)
    |> Enum.each(fn locations ->
      {:ok, {accepted, _}} = Persistence.bulk_insert_locations(locations)

      LocationsImportReport.report_accepted(accepted)
      LocationsImportReport.report_noop(length(locations) - accepted)
    end)

    report = LocationsImportReport.get_report()

    LocationsImportReport.clear_report()

    report
  end

  def import_locations(_, _), do: :file_not_supported
end
