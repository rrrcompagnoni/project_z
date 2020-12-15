defmodule Geolocation.Mocks.Workers.Locations do
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
