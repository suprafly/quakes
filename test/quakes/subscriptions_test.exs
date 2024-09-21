defmodule Quakes.SubscriptionsTest do
  use Quakes.DataCase, async: false

  alias Quakes.Subscriptions

  describe "subscriptions" do
    alias Quakes.Subscriptions.Subscription

    import Quakes.SubscriptionsFixtures

    @invalid_attrs %{endpoint: nil, id: nil, start: nil}

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert subscription in Subscriptions.list_subscriptions()
    end

    test "get_subscription/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Subscriptions.get_subscription(subscription.id) == {:ok, subscription}
    end

    test "create_subscription/1 with valid data creates a subscription" do
      valid_attrs = %{
        endpoint: "http://some.endpoint.com",
      }

      assert {:ok, %Subscription{} = subscription} = Subscriptions.create_subscription(valid_attrs)
      assert subscription.endpoint == "http://some.endpoint.com"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Subscriptions.create_subscription(@invalid_attrs)
    end
  end
end
