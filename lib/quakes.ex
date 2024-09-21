defmodule Quakes do
  @moduledoc """
  Quakes keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc"""
  Generates a unix timestamp with millisecond precision.
  """
  def unix_now_ms do
    DateTime.utc_now() |> DateTime.to_unix(:millisecond)
  end

  @doc"""
  Converts unix time (ms) to a `DateTime`.
  """
  def from_unix_ms!(ts) do
    DateTime.from_unix!(ts, :millisecond)
  end
end
