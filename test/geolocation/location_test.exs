defmodule Geolocation.LocationTest do
  use ExUnit.Case, async: true

  alias Geolocation.Location

  describe "cast_schema/1" do
    test "the conversion of a location from the persistence layer into a pure location struct" do
      assert %Location{} = Location.cast_schema(%Geolocation.Persistence.Location{})
    end
  end
end
