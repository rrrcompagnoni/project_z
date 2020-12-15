defmodule GeolocationWeb.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/locations" do
    with %{"ip-address" => ip_address} <- conn.params,
         {:ok, %Geolocation.Location{} = location} <-
           Geolocation.find_location(ip_address),
         {:ok, serialized_location} <- Jason.encode(location) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, serialized_location)
    else
      %{} -> send_404(conn)
      {:error, :location_not_found} -> send_404(conn)
    end
  end

  match(_, do: send_404(conn))

  defp send_404(conn), do: send_resp(conn, 404, "")
end
