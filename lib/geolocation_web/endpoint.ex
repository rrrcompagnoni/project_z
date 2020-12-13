defmodule GeolocationWeb.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  match(_, do: send_404(conn))

  defp send_404(conn), do: send_resp(conn, 404, "")
end
