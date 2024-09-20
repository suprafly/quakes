defmodule Quakes.QuakeNotifier do
  @moduledoc """
  `QuakeNotifier` is a simple module for encapsulating webhook dispatch logic.
  """

  alias Quakes.USGS.Quake

  @doc"""
  Receives a `quake` and an `endpoint` and *POSTS* the data to the endpoint.
  """
  def dispatch_event(%Quake{} = quake, endpoint) do
    opts = Application.get_env(:quakes, :quake_notifier_req_options, [])
    Req.new(
      method: :post,
      url: endpoint,
      body: Jason.encode!(quake),
      headers: headers(),
      plug: Keyword.get(opts, :plug)
      )
    |> Req.Request.run_request()
 end

  defp headers do
    [{"content-type", "application/json"}]
  end
end
