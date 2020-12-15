defmodule Geolocation.Mocks.Repo do
  def get_by(Geolocation.Persistence.Location, ip_address: "200.106.141.15") do
    %Geolocation.Persistence.Location{
      city: "DuBuquemouth",
      country: "Nepal",
      country_code: "SI",
      ip_address: "200.106.141.15",
      latitude: "-84.87503094689836",
      longitude: "7.206435933364332",
      mystery_value: "19321398717239"
    }
  end

  def get_by(Geolocation.Persistence.Location, ip_address: "192.168.1.1") do
    nil
  end

  def get_by(Geolocation.Persistence.Location, ip_address: "") do
    nil
  end
end
