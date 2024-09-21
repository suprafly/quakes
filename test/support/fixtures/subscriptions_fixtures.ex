defmodule Quakes.SubscriptionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Quakes.Subscriptions` context.
  """

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> Enum.into(%{endpoint: "http://some.endpoint.com"})
      |> Quakes.Subscriptions.create_subscription()

    subscription
  end
end
