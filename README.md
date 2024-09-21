# Quakes

A webhook service to deliver realtime earthquake events via the USGS API.

## Getting Started

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Run `mix ecto.create` to create the database.
  * Run `mix ecto.migrate` to migrate the database.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`


## API Docs

### Quake Webhooks

The `Quake` app will check the USGS API every minute for new quakes. If you have subscribed (see the API below) then you will receive `POST` requests to your suppied endpoint. The request payload will look like this,

```
{
  "type": "Feature",
  "properties": {
    "mag": 2.36,
    "place": "2km E of Commerce, CA",
    "time": 1618944913520,
    "updated": 1618945143221,
    "url": "https://earthquake.usgs.gov/earthquakes/eventpage/ci39857648",
    "detail": "https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/ci39857648.geojson",
    "tsunami": 0,
    "type": "earthquake",
    "title": "M 2.4 - 2km E of Commerce, CA"
  },
  "geometry": {
    "type": "Point",
    "coordinates": [
      -118.1325,
      34.0018333,
      16.86
    ]
  },
  "id": "ci39857648"
}
```

---

### Create Subscription

**POST** http://localhost:4000/subscriptions

Creates a new subscription with the given parameters.

#### Expected Payload Example

```
{
  "endpoint": "https://receiver.mywebservice.com/earthquakes",
  "filters": [
    {
      "type": "magnitude",
      "minimum": 1.0
    }
  ]
}
```

#### Required Fields

  * `"endpoint"` - a valid endpoint beginning with "http". This will be used to **POST** webhook events to.

#### Optional Fields

  * `"filters"` - a JSON object representing a filter.
    - *Required* - `"type"` - this can be any field name from the `"properties"` of a Quake event.
    - *Required* - A key-value pair the defines the filter operation.
                 -  Valid keys are: `["minimum", "maximum", "equal", "match"]`
                 - `"match"` is used to define a regex string.
                 - `["minimum", "maximum", "equal"]` are used to define comparison operations and require number values (integers or floats).

    - Filter stucture,
      ```
      {
        "type": "magnitude",
        "minimum": 1.0
      }
      ```

#### Response

Success will returns status code `200` with a body like this,

```
{
  "id": "5c49fcbd-4fa0-4781-bd4d-faad5fb7b383",
  "start": 1618958220000,
  "details": {
    "endpoint": "https://receiver.mywebservice.com/earthquakes",
    "filters": [
      {
        "type": "magnitude",
        "minimum": 1.0
      }
    ]
  }
}
```

*Note to reviewers - I used a UUID for the ID rather than something like `"KnXegis"` because It was not obvious how those ids were generated, and therefore it is not obvious how resilient they will be to collisions.*
