defmodule QuakesWeb.QuakeController do
  use QuakesWeb, :controller

  action_fallback QuakesWeb.FallbackController

  def within(conn, %{"longitude" => long, "latitude" => lat} = params) do
    distance_in_meters = Map.get(params, "distance", "100") |> to_float()
    with {:ok, quakes} <- Quakes.USGS.get_quakes_nearby(long, lat, distance_in_meters) do
      render(conn, :list, quakes: quakes)
    end
  end

  def within(conn, params) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(:error, params: params)
  end

  defp to_float(value) do
    case String.split(value, ".") do
      [value] -> "#{value}.0"
      _ -> value
    end
    |> String.to_float()
  end
end
