defmodule QuakesWeb.QuakeListenerController do
  use QuakesWeb, :controller

  def receive_event(conn, _params) do
    send_resp(conn, 200, "received")
  end
end
