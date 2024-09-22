defmodule Quakes.USGSApi.Impl do
  @moduledoc """
  The implementation for the USGS Api.
  """
  @behaviour Quakes.USGSApi.Behaviour

  def get_quakes(interval_type, duration) do
    interval_type
    |> create_request(duration)
    |> Req.Request.run_request()
    |> handle_response()
  end

  def get_quakes_for_past_month do
    Req.new(
      method: :get,
      url: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
      )
    |> Req.Request.run_request()
    |> handle_response()
  end

  defp create_request(interval_type, duration) do
    Req.new(
      method: :get,
      url: get_endpoint(interval_type, duration)
      )
  end

  defp handle_response({_request, %Req.Response{status: 200, body: body} = _response}) do
    body
  end

  defp get_endpoint(interval_type, duration) do
    slug = "#{duration}_#{interval_type}.geojson"
    Path.join(api_endpoint(), slug)
  end

  defp api_endpoint do
    "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/"
  end
end
