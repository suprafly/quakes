defmodule QuakesWeb.QuakeJSON do
  @moduledoc """
  Renders quakes.
  """

  @doc """
  Renders a single subscription.
  """
  def list(%{quakes: quakes}) do
    # Auto encoded by the schema
    quakes
  end

  @doc false
  def error(%{params: %{"longitude" => _}}) do
    error(%{msg: "latitude is required"})
  end

  def error(%{params: %{"latitude" => _}}) do
    error(%{msg: "longitude is required"})
  end

  def error(%{params: _}) do
    error(%{msg: "longitude and latitude are required"})
  end

  def error(%{msg: msg}) do
    %{error: msg}
  end
end
