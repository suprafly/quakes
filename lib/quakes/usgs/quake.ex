defmodule Quakes.USGS.Quake do
  @moduledoc"""
  The struct to hold information about quakes.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Quakes.USGS.Geometry
  alias Quakes.USGS.Properties
  alias Quakes.USGS.Quake

  @primary_key false
  @derive Jason.Encoder
  embedded_schema do 
    field :id, :string, primary_key: true
    field :type, :string

    embeds_one :properties, Properties, on_replace: :delete
    embeds_one :geometry, Geometry, on_replace: :delete
  end

  @doc false
  def changeset(%Quake{} = quake, attrs) do
    quake
    |> cast(attrs, [:id, :type])
    |> cast_embed(:properties, required: true)
    |> cast_embed(:geometry, required: true)
    |> validate_required([:id, :type])
  end
end
