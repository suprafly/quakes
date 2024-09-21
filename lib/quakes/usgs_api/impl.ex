defmodule Quakes.USGSApi.Impl do
  @moduledoc """
  The implementation for the USGS Api.
  """
  require Logger

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
    parsed_quakes = parse_quakes(body)
    errors = Map.get(parsed_quakes, :error)
    if errors do
      Logger.info "Failed to parse #{Enum.count(errors)} quakes"
    end
    Map.get(parsed_quakes, :ok, [])
  end

  defp get_endpoint(interval_type, duration) do
    slug = "#{duration}_#{interval_type}.geojson"
    Path.join(api_endpoint(), slug)
  end

  defp api_endpoint do
    "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/"
  end

  defp parse_quakes(%{"features" => features}) do
    features
    |> Enum.map(&Quakes.USGS.create_quake(&1))
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
  end

  defp parse_quakes(_body) do
    # There are no features, so return an empty list
    []
  end
end
