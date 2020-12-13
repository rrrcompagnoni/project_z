defmodule Geolocation.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table("locations") do
      add :ip_address, :string, null: false
      add :country_code, :string, null: false
      add :country, :string, null: false
      add :city, :string, null: false
      add :latitude, :string, null: false
      add :longitude, :string, null: false
      add :mystery_value, :string
    end

    create unique_index("locations", :ip_address)
  end
end
