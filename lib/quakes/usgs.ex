defmodule Quakes.USGS do
  @moduledoc """
  The USGS context. This is the Api for creating `Quake` structs.
  """

  import Ecto.Query, warn: false

  alias Quakes.Repo
  alias Quakes.USGS.Quake

  @doc """
  Creates a quake.

  ## Examples

      iex> create_quake(%{field: value})
      {:ok, %Quake{}}

      iex> create_quake(%{field: bad_value})
      {:error, ...}

  """
  def create_quake(attrs \\ %{}) do
    %Quake{}
    |> Quake.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single quake.
  """
  def get_quake(id) do
    (from q in Quake, where: q.id == ^id)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      quake -> {:ok, quake}
    end
  end

  @doc"""
  Gets all quakes within a given `distance_in_meters` from the coordinates provided.
  """
  def get_quakes_nearby(longitude, latitude, distance_in_meters) do
    case Geo.WKT.decode("SRID=4326;POINT(#{longitude} #{latitude})") do
      {:ok, point} ->
        quakes =
          (from q in Quake,
            where: fragment(
              "ST_DWithin(ST_GeomFromGeoJSON(?), ?, ?)",
              q.geometry,
              ^point,
              ^distance_in_meters
            )
          ) |> Repo.all()
        {:ok, quakes}
      {:error, _} ->
        {:error, "invalid longitude, latitude values."}
      end
  end
end
