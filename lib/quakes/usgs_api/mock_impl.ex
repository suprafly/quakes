defmodule Quakes.USGSApi.MockImpl do
  @moduledoc """
  The mock implementation for the USGS Api.
  """
  require Logger

  @behaviour Quakes.USGSApi.Behaviour

  def get_quakes(_interval_type, _duration) do
    """
    {
      "type": "FeatureCollection",
      "metadata": {
        "generated": 1726793902000,
        "url": "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/1.0_hour.geojson",
        "title": "USGS Magnitude 1.0+ Earthquakes, Past Hour",
        "status": 200,
        "api": "1.10.3",
        "count": 2
      },
      "features": [
        {
          "type": "Feature",
          "properties": {
            "mag": 1.72,
            "place": "20 km NW of Grapevine, CA",
            "time": 1726792203250,
            "updated": 1726792868250,
            "tz": null,
            "url": "https://earthquake.usgs.gov/earthquakes/eventpage/ci40739335",
            "detail": "https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ci40739335.geojson",
            "felt": null,
            "cdi": null,
            "mmi": null,
            "alert": null,
            "status": "automatic",
            "tsunami": 0,
            "sig": 46,
            "net": "ci",
            "code": "40739335",
            "ids": ",ci40739335,",
            "sources": ",ci,",
            "types": ",focal-mechanism,nearby-cities,origin,phase-data,scitech-link,",
            "nst": 46,
            "dmin": 0.01887,
            "rms": 0.22,
            "gap": 63,
            "magType": "ml",
            "type": "earthquake",
            "title": "M 1.7 - 20 km NW of Grapevine, CA"
          },
          "geometry": {
            "type": "Point",
            "coordinates": [
              -119.0828333,
              35.0775,
              12.25
            ]
          },
          "id": "ci40739335"
        },
        {
          "type": "Feature",
          "properties": {
            "mag": 2.42,
            "place": "23 km W of Volcano, Hawaii",
            "time": 1726790555330,
            "updated": 1726790727560,
            "tz": null,
            "url": "https://earthquake.usgs.gov/earthquakes/eventpage/hv74470587",
            "detail": "https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/hv74470587.geojson",
            "felt": null,
            "cdi": null,
            "mmi": null,
            "alert": null,
            "status": "automatic",
            "tsunami": 0,
            "sig": 90,
            "net": "hv",
            "code": "74470587",
            "ids": ",hv74470587,",
            "sources": ",hv,",
            "types": ",origin,phase-data,",
            "nst": 51,
            "dmin": 0.062,
            "rms": 0.189999998,
            "gap": 34,
            "magType": "ml",
            "type": "earthquake",
            "title": "M 2.4 - 23 km W of Volcano, Hawaii"
          },
          "geometry": {
            "type": "Point",
            "coordinates": [
              -155.455505371094,
              19.4675006866455,
              2.59999990463257
            ]
          },
          "id": "hv74470587"
        }
      ],
      "bbox": [
        -155.45550537109,
        19.467500686646,
        2.5999999046326,
        -119.0828333,
        35.0775,
        12.25
      ]
    }
    """
    |> Jason.decode!()
    |> Map.get("features")
    |> Enum.reduce([], fn attrs, acc ->
      case Quakes.USGS.create_quake(attrs) do
        {:ok, quake} -> [quake | acc]
        _ -> acc
      end
    end)
  end
end
