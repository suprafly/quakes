defmodule Quakes do
  @moduledoc """
  Quakes keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  require Logger

  @doc"""
  Generates a unix timestamp with millisecond precision.
  """
  def unix_now_ms do
    DateTime.utc_now() |> DateTime.to_unix(:millisecond)
  end

  @doc"""
  Converts unix time (ms) to a `DateTime`.
  """
  def from_unix_ms!(ts) do
    DateTime.from_unix!(ts, :millisecond)
  end

  @doc"""
  Receives the `response_body` from the API request and
  parses and ingests the quakes from it.
  """
  def ingest_quakes(response_body) do
    parsed_quakes = parse_quakes(response_body)
    errors = Map.get(parsed_quakes, :error)
    if errors do
      Logger.info "Failed to parse #{Enum.count(errors)} quakes"
    end
    Map.get(parsed_quakes, :ok, [])
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
