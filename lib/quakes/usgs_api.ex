defmodule Quakes.USGSApi do
  @moduledoc """
  This module is the interface to the USGS Api.
  """
  require Logger

  @behaviour Quakes.USGSApi.Behaviour

  @doc"""
  Gets the most recent quakes.
  """
  def get_quakes(interval_type \\ :hour, duration \\ 1.0) do
    module = Application.get_env(:quakes, :usgs_api, Quakes.USGSApi.Impl)
    module.get_quakes(interval_type, duration)
  end

  def get_quakes_for_past_month do
    module = Application.get_env(:quakes, :usgs_api, Quakes.USGSApi.Impl)
    module.get_quakes_for_past_month()
  end
end
