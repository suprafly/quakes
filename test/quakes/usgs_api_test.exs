defmodule Quakes.USGSApiTest do
  use Quakes.DataCase

  alias Quakes.USGSApi

  describe "api" do
    alias Quakes.USGS.Quake

    test "get_quakes/0 with gets a list of quakes" do
      quakes = USGSApi.get_quakes()

      assert Enum.count(quakes) == 2

      Enum.each(quakes, fn q ->
        assert q.__struct__ == Quake
      end)
    end
  end
end
