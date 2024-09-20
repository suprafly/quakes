defmodule Quakes.USGS do
  @moduledoc """
  The USGS context. This is the Api for creating `Quake` structs.
  """

  import Ecto.Query, warn: false

  # alias Quakes.Repo
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
    |> case do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, Ecto.Changeset.apply_changes(changeset)}
      changeset ->
        {:error, changeset}
    end
  end

  # @doc """
  # Returns the list of quakes.

  # ## Examples

  #     iex> list_quakes()
  #     [%Quake{}, ...]

  # """
  # def list_quakes do
  #   raise "TODO"
  # end

  # @doc """
  # Gets a single quake.

  # Raises if the Quake does not exist.

  # ## Examples

  #     iex> get_quake!(123)
  #     %Quake{}

  # """
  # def get_quake!(id), do: raise "TODO"


  # @doc """
  # Updates a quake.

  # ## Examples

  #     iex> update_quake(quake, %{field: new_value})
  #     {:ok, %Quake{}}

  #     iex> update_quake(quake, %{field: bad_value})
  #     {:error, ...}

  # """
  # def update_quake(%Quake{} = quake, attrs) do
  #   raise "TODO"
  # end

  # @doc """
  # Deletes a Quake.

  # ## Examples

  #     iex> delete_quake(quake)
  #     {:ok, %Quake{}}

  #     iex> delete_quake(quake)
  #     {:error, ...}

  # """
  # def delete_quake(%Quake{} = quake) do
  #   raise "TODO"
  # end

  # @doc """
  # Returns a data structure for tracking quake changes.

  # ## Examples

  #     iex> change_quake(quake)
  #     %Todo{...}

  # """
  # def change_quake(%Quake{} = quake, _attrs \\ %{}) do
  #   raise "TODO"
  # end
end
