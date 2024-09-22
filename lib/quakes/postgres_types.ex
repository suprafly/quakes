# Custom types

Postgrex.Types.define(
  Quakes.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
  )
