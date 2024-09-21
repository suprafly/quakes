defmodule QuakesWeb.SubscriptionController do
  use QuakesWeb, :controller

  action_fallback QuakesWeb.FallbackController

  def create(conn, params) do
    with attrs <- Map.take(params, ["endpoint", "filters"]),
         {:ok, subscription} <- Quakes.Subscriptions.create_subscription(attrs) do
      render(conn, :show, subscription: subscription)
    end
  end
end
