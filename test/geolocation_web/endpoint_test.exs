defmodule GeolocationWeb.EndpointTest do
  use Geolocation.RepoCase, async: true
  use Plug.Test

  @opts GeolocationWeb.Endpoint.init([])

  describe "GET /locations" do
    test "a match in a location" do
      response =
        :get
        |> conn("/locations?ip-address=200.106.141.15")
        |> put_req_header("content-type", "application/json")
        |> GeolocationWeb.Endpoint.call(@opts)

      assert response.status == 200

      assert %{
               "city" => "DuBuquemouth",
               "country" => "Nepal",
               "country_code" => "SI",
               "ip_address" => "200.106.141.15",
               "latitude" => "-84.87503094689836",
               "longitude" => "7.206435933364332"
             } = Jason.decode!(response.resp_body)
    end

    test "empty ip address" do
      response =
        :get
        |> conn("/locations?ip-address=")
        |> put_req_header("content-type", "application/json")
        |> GeolocationWeb.Endpoint.call(@opts)

      assert response.status == 404

      assert "" = response.resp_body
    end

    test "missing the ip address param" do
      response =
        :get
        |> conn("/locations")
        |> put_req_header("content-type", "application/json")
        |> GeolocationWeb.Endpoint.call(@opts)

      assert response.status == 404

      assert "" = response.resp_body
    end

    test "not a match in a location" do
      response =
        :get
        |> conn("/locations?ip-address=192.168.1.1")
        |> put_req_header("content-type", "application/json")
        |> GeolocationWeb.Endpoint.call(@opts)

      assert response.status == 404

      assert "" = response.resp_body
    end
  end
end
