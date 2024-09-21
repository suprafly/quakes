defmodule Quakes.Subscriptions do
  @moduledoc """
  The Subscriptions context.
  """

  # import Ecto.Query, warn: false
  # alias Quakes.Repo

  alias Quakes.Subscriptions.Subscription

  @ets_table :subscriptions

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    @ets_table
    |> :ets.tab2list()
    |> Enum.map(&elem(&1, 1))
  end


  @doc """
  Gets a single subscription.

  Raises if the Subscription does not exist.

  ## Examples

      iex> get_subscription(123)
      {:ok, %Subscription{}}

  """
  def get_subscription(id) do
    case :ets.lookup(@ets_table, id) do
      [{_id, subscription}] -> {:ok, subscription}
      _ -> {:error, :not_found}
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
    %Subscription{
      id: Ecto.UUID.generate(),
      start: Quakes.unix_now_ms
    }
    |> Subscription.changeset(attrs)
    |> case do
      %Ecto.Changeset{valid?: true} = changeset ->
        subscription = Ecto.Changeset.apply_changes(changeset)
        :ets.insert_new(@ets_table, {subscription.id, subscription})
        {:ok, subscription}
      changeset ->
        {:error, changeset}
    end
  end
end
