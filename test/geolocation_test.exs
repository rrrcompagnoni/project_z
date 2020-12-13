defmodule GeolocationTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  defmodule GeolocationTest.FakeWorker do
    def import_locations(_, ".csv") do
      %{
        accepted: 15,
        discarded: 3,
        noop: 0
      }
    end

    def import_locations(_, _) do
      :file_not_supported
    end
  end

  describe "import_locations/1" do
    test "the report result when things goes well with the import" do
      start_at = DateTime.now!("Etc/UTC")

      assert capture_log(fn ->
               :ok =
                 Geolocation.import_locations("data.csv", start_at, GeolocationTest.FakeWorker)
             end) =~ ~s"""
             Locations import report
             Imported: 15
             Discarded: 3
             Noop: 0
             Elapsed time 0 seconds.
             """
    end

    test "the report result when a wrong file is provided" do
      start_at = DateTime.now!("Etc/UTC")

      assert capture_log(fn ->
               :ok =
                 Geolocation.import_locations("data.json", start_at, GeolocationTest.FakeWorker)
             end) =~ "The file provided is not supported."
    end
  end
end
