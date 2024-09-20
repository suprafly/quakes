defmodule QuakesWeb.QuakeListenerController do
  use QuakesWeb, :controller

  def receive_event(conn, _params) do
    # IO.inspect _params["id"], label: :quake_id

    send_resp(conn, 200, "received")
  end
end
