defmodule Quakes.FiltersTest do
  use Quakes.DataCase

  alias Quakes.Filters
  alias Quakes.Filters.Filter

  describe "changesets" do
    test "valid filters" do
      attrs = %{"type" => "magnitude", "minimum" => 2.0}
      assert %Ecto.Changeset{valid?: true} = Filter.changeset(%Filter{}, attrs)

      attrs = %{"type" => "updated", "maximum" => 1618945143221}
      assert %Ecto.Changeset{valid?: true} = Filter.changeset(%Filter{}, attrs)

      attrs = %{"type" => "time", "equal" => 1618944913520}
      assert %Ecto.Changeset{valid?: true} = Filter.changeset(%Filter{}, attrs)

      attrs = %{"type" => "place", "match" => "Commerce, CA$"}
      assert %Ecto.Changeset{valid?: true} = Filter.changeset(%Filter{}, attrs)
    end

    test "invalid filters" do
      attrs = %{"type" => "magnitude", "minimum" => "2.0"}
      assert %Ecto.Changeset{
        valid?: false,
        errors: [
          filter_params: {"minimum must have a value that is a number (integer or float)",
           []}
        ]} = Filter.changeset(%Filter{}, attrs)

      attrs = %{"type" => "updated", "maximum" => "1618945143221"}
      assert %Ecto.Changeset{
        valid?: false,
        errors: [
          filter_params: {"maximum must have a value that is a number (integer or float)",
           []}
        ]} = Filter.changeset(%Filter{}, attrs)

      attrs = %{"type" => "time", "equal" => "1618944913520"}
      assert %Ecto.Changeset{
        valid?: false,
        errors: [
          filter_params: {"equal must have a value that is a number (integer or float)",
           []}
        ]} = Filter.changeset(%Filter{}, attrs)

      attrs = %{"type" => "place", "match" => 10}
      assert %Ecto.Changeset{
        valid?: false,
        errors: [
          filter_params: {"match must have a value that is a string", []}
        ]} = Filter.changeset(%Filter{}, attrs)
    end
  end

  describe "filtering" do
    import Quakes.USGSFixtures
    import Quakes.SubscriptionsFixtures

    test "filter_quake/2 with minimum filter that selects the quake" do
      quake = quake_fixture()
      filter_attrs = %{"type" => "magnitude", "minimum" => 2.0}
      subscription = subscription_fixture(%{filters: [filter_attrs]})
      assert Filters.filter_quake(quake, subscription) == quake
    end

    test "filter_quake/2 with minimum filter that discards the quake" do
      quake = quake_fixture()
      filter_attrs = %{"type" => "magnitude", "minimum" => 3.0}
      subscription = subscription_fixture(%{filters: [filter_attrs]})
      assert Filters.filter_quake(quake, subscription) == nil
    end

    test "filter_quake/2 with maximum filter that selects the quake" do
      quake = quake_fixture()
      filter_attrs = %{"type" => "magnitude", "maximum" => 4.0}
      subscription = subscription_fixture(%{filters: [filter_attrs]})
      assert Filters.filter_quake(quake, subscription) == quake
    end

    test "filter_quake/2 with maximum filter that discards the quake" do
      quake = quake_fixture()
      filter_attrs = %{"type" => "magnitude", "maximum" => 1.0}
      subscription = subscription_fixture(%{filters: [filter_attrs]})
      assert Filters.filter_quake(quake, subscription) == nil
    end

    test "filter_quake/2 with equal filter that selects the quake" do
      quake = quake_fixture()
      filter_attrs = %{"type" => "magnitude", "maximum" => 2.36}
      subscription = subscription_fixture(%{filters: [filter_attrs]})
      assert Filters.filter_quake(quake, subscription) == quake
    end

    test "filter_quake/2 with equal filter that discards the quake" do
      quake = quake_fixture()
      filter_attrs = %{"type" => "magnitude", "maximum" => 2.3}
      subscription = subscription_fixture(%{filters: [filter_attrs]})
      assert Filters.filter_quake(quake, subscription) == nil
    end

    test "filter_quake/2 with match filter that selects the quake" do
      quake = quake_fixture()
      filter_attrs = %{"type" => "place", "match" => "Commerce, CA$"}
      subscription = subscription_fixture(%{filters: [filter_attrs]})
      assert Filters.filter_quake(quake, subscription) == quake
    end

    test "filter_quake/2 with match filter that discards the quake" do
      quake = quake_fixture()
      filter_attrs = %{"type" => "place", "match" => "Commerce$"}
      subscription = subscription_fixture(%{filters: [filter_attrs]})
      assert Filters.filter_quake(quake, subscription) == nil
    end
  end
end
