defmodule QuakesWeb.QuakeControllerTest do
  use QuakesWeb.ConnCase

  alias Quakes.USGS
  alias Quakes.USGS.Quake

  describe "/quakes/within" do
    test "GET a finds a quake within the given parameters", %{conn: conn} do
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

      assert {:ok, %Quake{id: quake_id}} = USGS.create_quake(valid_attrs)

      conn = get(conn, ~p"/quakes/within?longitude=-95.570867&latitude=37.095400&distance=100")
      assert [%{"id" => ^quake_id}] = json_response(conn, 200)
    end

    test "GET returns []", %{conn: conn} do
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

      conn = get(conn, ~p"/quakes/within?longitude=-95.570867&latitude=37.095400&distance=1")
      assert [] = json_response(conn, 200)
    end

    test "GET error - no latitude", %{conn: conn} do
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

      conn = get(conn, ~p"/quakes/within?longitude=-95.570867")
      assert %{"error" => "latitude is required"} = json_response(conn, 422)
    end

    test "GET error - no longitude", %{conn: conn} do
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

      conn = get(conn, ~p"/quakes/within?latitude=37.095400&distance=1")
      assert %{"error" => "longitude is required"} = json_response(conn, 422)
    end

    test "GET error - no latitude or longitude", %{conn: conn} do
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

      conn = get(conn, ~p"/quakes/within")
      assert %{"error" => "longitude and latitude are required"} = json_response(conn, 422)
    end
  end
end
