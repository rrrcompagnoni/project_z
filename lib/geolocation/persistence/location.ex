defmodule Geolocation.Persistence.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @permitted [
    :ip_address,
    :country_code,
    :country,
    :city,
    :latitude,
    :longitude,
    :mystery_value
  ]

  @required [
    :ip_address,
    :country_code,
    :country,
    :city,
    :latitude,
    :longitude
  ]

  schema "locations" do
    field(:ip_address, :string)
    field(:country_code, :string)
    field(:country, :string)
    field(:city, :string)
    field(:latitude, :string)
    field(:longitude, :string)
    field(:mystery_value, :string)
  end

  def changeset(location, attributes \\ %{}) do
    location
    |> cast(attributes, @permitted)
    |> validate_required(@required)
    |> validate_ip_addess_format()
    |> unique_constraint(:ip_address)
  end

  defp validate_ip_addess_format(changeset) do
    validate_change(changeset, :ip_address, fn :ip_address, ip_address ->
      case :inet.parse_strict_address(String.to_charlist(ip_address)) do
        {:ok, _} -> []
        {:error, :einval} -> [ip_address: "invalid format"]
      end
    end)
  end
end
