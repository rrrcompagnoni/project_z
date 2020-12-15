defmodule Geolocation.Workers.LocationsTest do
  use Geolocation.RepoCase, async: true

  alias Geolocation.Machinery.LocationsImportReport
  alias Geolocation.Workers.Locations

  describe "import_locations/1" do
    test "an import with a CSV file" do
      assert %LocationsImportReport{accepted: 18, discarded: 1, noop: 0} =
               Locations.import_locations(
                 "test/support/sample_data.csv",
                 ".csv"
               )

      assert %LocationsImportReport{accepted: 0, discarded: 0, noop: 0}
    end

    test "not a CSV file" do
      assert Locations.import_locations("sample_data.json", ".json") == :file_not_supported
    end
  end
end
