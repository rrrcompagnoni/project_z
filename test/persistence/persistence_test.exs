defmodule Geolocation.PersistenceTest do
  use Geolocation.RepoCase, async: true

  alias Geolocation.Persistence

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

      assert Persistence.valid_location_attributes?(attributes) == true
    end

    test "invalid attributes" do
      assert Persistence.valid_location_attributes?(%{}) == false
    end
  end

  describe "insert_location/1" do
    test "an import with success" do
      attributes = %{
        city: "DuBuquemouth",
        country: "Nepal",
        country_code: "SI",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332",
        mystery_value: "19321398717239"
      }

      assert {:ok, _} = Persistence.insert_location(attributes)
    end

    test "a failure on importing" do
      assert {:error, _} = Persistence.insert_location(%{})
    end
  end

  describe "bulk_insert_locations" do
    test "insert idempotence" do
      attributes = %{
        city: "DuBuquemouth",
        country: "Nepal",
        country_code: "SI",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332"
      }

      assert {:ok, {1, nil}} =
               Persistence.bulk_insert_locations([
                 attributes,
                 attributes
               ])

      assert Persistence.count_locations() == 1
    end

    test "the rollback when somehting goes wrong" do
      attributes = %{
        city: "DuBuquemouth",
        country: "Nepal",
        country_code: "SI",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332"
      }

      assert_raise Postgrex.Error, fn ->
        Persistence.bulk_insert_locations([
          # valid location attributes
          attributes,
          # invalid location attributes
          %{}
        ])
      end

      assert Persistence.count_locations() == 0
    end
  end

  describe "count_locations" do
    test "with locations" do
      attributes = %{
        city: "DuBuquemouth",
        country: "Nepal",
        country_code: "SI",
        ip_address: "200.106.141.15",
        latitude: "-84.87503094689836",
        longitude: "7.206435933364332"
      }

      {:ok, _} = Persistence.insert_location(attributes)

      assert Persistence.count_locations() == 1
    end

    test "without locations" do
      assert Persistence.count_locations() == 0
    end
  end
end
