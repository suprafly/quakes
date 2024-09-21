defmodule Quakes.Filters do
  @moduledoc """
  Context functions for Filters.
  """
  alias Quakes.Filters.Filter
  alias Quakes.Subscriptions.Subscription
  alias Quakes.USGS.Quake

  @doc"""
  Receives a `quake` and a `subscription` and runs the `quake` through any
  filters defined on the `subscription`.

  Returns the quake if it passes through, or `nil` if the quake was filtered out.
  """
  def filter_quake(%Quake{} = quake, %Subscription{} = subscription) do
    Enum.reduce(subscription.filters, quake, fn
      _, nil -> nil
      filter, quake -> apply_filter(quake, filter)
    end)
  end

  defp apply_filter(quake, filter) do
    field = Filter.field_for_type(filter.type)
    value = Map.get(quake.properties, field)

    filter.filter_params
    |> Filter.filter_params_as_key_value()
    |> do_apply_filter(value)
    |> case do
        nil -> quake
        true -> quake
        false -> nil
      end
  end

  defp do_apply_filter({"minimum", filter_value}, value) when is_number(filter_value) and is_number(value) do
    value >= filter_value
  end

  defp do_apply_filter({"maximum", filter_value}, value) when is_number(filter_value) and is_number(value) do
    value <= filter_value
  end

  defp do_apply_filter({"equal", filter_value}, value) when is_number(filter_value) and is_number(value) do
    value == filter_value
  end

  defp do_apply_filter({"match", filter_value}, value) when is_binary(filter_value) and is_binary(value) do
    case Regex.compile(filter_value) do
      {:ok, regex} ->
        Regex.match?(regex, value)
      {:error, _} ->
        # It is an invalid regex, so fall through and do not apply
        nil
    end
  end

  defp do_apply_filter({_, _}, _value) do
    # If the filter is not defined, let the quake pass through
    nil
  end
end
