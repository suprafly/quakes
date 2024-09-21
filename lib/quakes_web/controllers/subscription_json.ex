defmodule QuakesWeb.SubscriptionJSON do
  @moduledoc """
  Renders subscriptions.
  """
  alias Quakes.Filters.Filter
  alias Quakes.Subscriptions.Subscription

  @doc """
  Renders a single subscription.
  """
  def show(%{subscription: subscription}) do
    data(subscription)
  end

  defp data(%Subscription{} = subscription) do
    %{
      id: subscription.id,
      start: DateTime.to_unix(subscription.start, :millisecond),
      details: %{
        endpoint: subscription.endpoint,
        filters: filters(subscription),
      }
    }
  end

  defp filters(%Subscription{filters: filters}) do
    Enum.map(filters, fn filter ->
      {k, v} = Filter.filter_params_as_key_value(filter.filter_params)
      %{"type" => filter.type, "#{k}" => v}
    end)
  end
end
