defmodule Geolocation.Location do
  @keys [:city, :country, :country_code, :ip_address, :latitude, :longitude]

  @enforce_keys @keys

  @derive {Jason.Encoder, only: @keys}

  defstruct city: "",
            country: "",
            country_code: "",
            ip_address: "",
            latitude: "",
            longitude: "",
            mystery_value: ""

  def cast_schema(%Geolocation.Persistence.Location{} = location) do
    attributes = Map.drop(location, [:id, :__meta__, :__struct__])

    %__MODULE__{
      city: attributes.city,
      country: attributes.country,
      country_code: attributes.country_code,
      ip_address: attributes.ip_address,
      latitude: attributes.latitude,
      longitude: attributes.longitude,
      mystery_value: attributes.mystery_value
    }
  end
end
