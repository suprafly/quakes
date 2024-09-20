defmodule Quakes.USGSFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Quakes.USGS` context.
  """

  @doc """
  Generate a quake.
  """
  def quake_fixture(attrs \\ %{}) do
    properties = %{
      mag: 2.36,
      place: "2km E of Commerce, CA",
      time: 1618944913520,
      updated: 1618945143221,
      url: "https://earthquake.usgs.gov/earthquakes/eventpage/ci39857648",
      detail: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ci39857648.geojson",
      tsunami: 0,
      type: "earthquake",
      title: "M 2.4 - 2km E of Commerce, CA"
    }

    geometry = %{
      type: "Point",
      coordinates: [
          -118.1325,
          34.0018333,
          16.86
      ]
    }

    valid_attrs = %{
      id: "ci39857648",
      type: "Feature",
      properties: properties,
      geometry: geometry
    }

    {:ok, quake} =
      attrs
      |> Enum.into(valid_attrs)
      |> Quakes.USGS.create_quake()

    quake
  end
end
