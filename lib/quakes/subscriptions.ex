defmodule Quakes.Subscriptions do
  @moduledoc """
  The Subscriptions context.
  """

  import Ecto.Query, warn: false

  alias Quakes.Repo
  alias Quakes.Subscriptions.Subscription

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    Repo.all(Subscription)
  end


  @doc """
  Gets a single subscription.

  ## Examples

      iex> get_subscription(123)
      {:ok, %Subscription{}}

  """
  def get_subscription(id) do
    (from s in Subscription, where: s.id == ^id)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      subscription -> {:ok, subscription}
    end
  end

  @doc """
  Gets a subscription.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, ...}

  """
  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end
end
