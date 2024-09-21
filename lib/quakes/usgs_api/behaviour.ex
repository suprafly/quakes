defmodule Quakes.USGSApi.Behaviour do
  @moduledoc """
  The behaviour that defines the USGS Api.
  """
  alias Quakes.USGS.Quake

  @callback get_quakes(interval_type :: atom(), duration :: float()) :: payload :: [Quake.t()]
  @callback get_quakes_for_past_month() :: payload :: [Quake.t()]
end
