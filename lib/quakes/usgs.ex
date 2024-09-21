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
end
