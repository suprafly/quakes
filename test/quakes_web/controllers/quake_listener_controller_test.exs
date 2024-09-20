defmodule QuakesWeb.QuakeListenerControllerTest do
  use QuakesWeb.ConnCase

  test "POST /", %{conn: conn} do
    conn = post(conn, ~p"/listen/quakes/")
    assert response(conn, 200) =~ "received"
  end
end
