defmodule Geolocation.Persistence do
  alias Geolocation.Persistence.Location
  alias Geolocation.Repo

  import Ecto.Query

  def valid_location_attributes?(attributes) do
    Location.changeset(%Location{}, attributes).valid?
  end

  def insert_location(attributes) do
    %Location{}
    |> Location.changeset(attributes)
    |> Repo.insert()
  end

  def bulk_insert_locations(locations) do
    Repo.transaction(fn ->
      Repo.insert_all(Location, locations, on_conflict: :nothing)
    end)
  end

  def count_locations do
    Repo.aggregate(from(l in "locations"), :count, :id)
  end
end
