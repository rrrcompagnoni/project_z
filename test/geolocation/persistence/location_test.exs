defmodule Geolocation.Schemas.LocationTest do
  use Geolocation.RepoCase, async: true

  alias Geolocation.Schemas.Location

  @attributes %{
    city: "DuBuquemouth",
    country: "Nepal",
    country_code: "SI",
    ip_address: "200.106.141.15",
    latitude: "-84.87503094689836",
    longitude: "7.206435933364332"
  }

  describe "changeset/2" do
    test "the required fields" do
      assert %Ecto.Changeset{
               errors: [
                 ip_address: {"can't be blank", _},
                 country_code: {"can't be blank", _},
                 country: {"can't be blank", _},
                 city: {"can't be blank", _},
                 latitude: {"can't be blank", _},
                 longitude: {"can't be blank", _}
               ]
             } = Location.changeset(%Location{}, %{})
    end

    test "ip address unique constraint" do
      %Location{}
      |> Location.changeset(@attributes)
      |> Geolocation.Repo.insert!()

      changeset =
        %Location{}
        |> Location.changeset(@attributes)
        |> Geolocation.Repo.insert()

      assert {:error,
              %Ecto.Changeset{
                errors: [ip_address: {"has already been taken", _}]
              }} = changeset
    end

    test "a malformed ip address" do
      assert %Ecto.Changeset{
               errors: [
                 ip_address: {"invalid format", _}
               ]
             } = Location.changeset(%Location{}, %{@attributes | ip_address: "192.168.1."})
    end
  end
end
