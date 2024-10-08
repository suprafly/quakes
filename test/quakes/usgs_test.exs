defmodule Quakes.USGSTest do
  use Quakes.DataCase

  alias Quakes.USGS

  describe "quakes" do
    alias Quakes.USGS.Quake

    test "create_quake/1 with valid data creates a quake" do
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

      assert {:ok, %Quake{} = quake} = USGS.create_quake(valid_attrs)
      assert quake.type == "Feature"
    end

    test "create_quake/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{
        errors: [
          id: {"can't be blank", [validation: :required]},
          type: {"can't be blank", [validation: :required]},
          geometry: {"can't be blank", [validation: :required]},
          properties: {"can't be blank", [validation: :required]}
        ],
        valid?: false}} = USGS.create_quake(%{})
    end

    test "create_quake/1 with valid data then get_quake/1" do
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

      assert {:ok, %Quake{} = quake} = USGS.create_quake(valid_attrs)
      assert {:ok, ^quake} = USGS.get_quake(quake.id)
    end

    test "get_quakes_nearby/3 finds quakes within the given distance" do
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

      assert {:ok, %Quake{} = quake} = USGS.create_quake(valid_attrs)
      assert {:ok, [^quake]} = USGS.get_quakes_nearby(-95.570867, 37.095400, 100)
    end

    test "get_quakes_nearby/3 does not finds quakes if the given distance is too great" do
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

      assert {:ok, %Quake{}} = USGS.create_quake(valid_attrs)
      assert {:ok, []} = USGS.get_quakes_nearby(-95.570867, 37.095400, 2)
    end
  end
end
