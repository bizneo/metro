defmodule Metro.Router do
  use Plug.Router

  plug(Metro.Plug)

  match _ do
    send_resp(conn, 404, "Not found")
  end
end
