defmodule Metro.Router do
  use Plug.Router

  plug Metro.MetricsPlug

  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
