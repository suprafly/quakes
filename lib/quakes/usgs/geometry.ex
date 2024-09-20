defmodule Quakes.USGS.Geometry do
  @moduledoc"""
  The struct to hold information about geometry associated with quakes.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Quakes.USGS.Geometry

  @primary_key false
  @derive Jason.Encoder
  embedded_schema do 
    field :type, :string
    field :coordinates, {:array, :float}
  end

  @doc false
  def changeset(%Geometry{} = geometry, attrs) do
    geometry
    |> cast(attrs, [:type, :coordinates])
    |> validate_required([:type, :coordinates])
  end
end
