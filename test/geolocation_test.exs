defmodule GeolocationTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  alias Geolocation.Location

  describe "import_locations/1" do
    test "the report result when things goes well with the import" do
      start_at = DateTime.now!("Etc/UTC")

      assert capture_log(fn ->
               :ok = Geolocation.import_locations("data.csv", start_at)
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
               :ok = Geolocation.import_locations("data.json", start_at)
             end) =~ "The file provided is not supported."
    end
  end

  describe "bulk_insert_locations" do
    test "insert idempotence" do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Geolocation.Repo)

      attributes = %{
        city: "DuBuquemouth",
        country: "Nepal",
        country_code: "SI",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332"
      }

      # 1 here means the number of inserts.
      # https://hexdocs.pm/ecto/Ecto.Repo.html#c:insert_all/3
      assert {:ok, {1, nil}} =
               Geolocation.bulk_insert_locations([
                 attributes,
                 attributes
               ])
    end

    test "the rollback when somehting goes wrong" do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(Geolocation.Repo)

      attributes = %{
        city: "DuBuquemouth",
        country: "Nepal",
        country_code: "SI",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332"
      }

      assert_raise Postgrex.Error, fn ->
        Geolocation.bulk_insert_locations([
          # valid location attributes
          attributes,
          # invalid location attributes
          %{}
        ])
      end
    end
  end

  describe "valid_location_attributes?/1" do
    test "valid attributes" do
      attributes = %{
        city: "DuBuquemouth",
        country: "Nepal",
        country_code: "SI",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332",
        mystery_value: "19321398717239"
      }

      assert Geolocation.valid_location_attributes?(attributes) == true
    end

    test "invalid attributes" do
      assert Geolocation.valid_location_attributes?(%{}) == false
    end
  end

  describe "find_location/1" do
    test "an existent location" do
      assert {:ok,
              %Location{
                city: "DuBuquemouth",
                country: "Nepal",
                country_code: "SI",
                ip_address: "200.106.141.15",
                latitude: "-84.87503094689836",
                longitude: "7.206435933364332",
                mystery_value: "19321398717239"
              }} = Geolocation.find_location("200.106.141.15")
    end

    test "a not existent location" do
      assert {:error, :location_not_found} = Geolocation.find_location("192.168.1.1")
    end
  end
end
