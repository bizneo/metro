defmodule Metro.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  plug Metro.MetricsPlug

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
