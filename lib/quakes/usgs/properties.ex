defmodule Quakes.USGS.Properties do
  @moduledoc"""
  The struct to hold information about properties associated with quakes.
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Quakes.USGS.Properties

  @primary_key false
  @derive Jason.Encoder
  embedded_schema do 
    field :detail, :string
    field :mag, :float
    field :place, :string
    field :time, :integer
    field :title, :string
    field :tsunami, :integer
    field :type, :string
    field :updated, :integer
    field :url, :string
  end

  @doc false
  def changeset(%Properties{} = properties, attrs) do
    properties
    |> cast(attrs, [:mag, :place, :time, :updated, :url, :detail, :tsunami, :type, :title])
    |> validate_required([:mag, :place, :time, :updated, :url, :detail, :tsunami, :type, :title])
  end
end
