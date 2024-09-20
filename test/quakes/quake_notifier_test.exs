defmodule Quakes.QuakeNotifierTest do
  use Quakes.DataCase

  alias Quakes.QuakeNotifier

  describe "quake_notifier" do
    alias Quakes.USGS.Quake

    test "dispatch_event/2 sends a webhook event" do
      Req.Test.stub(Quakes.QuakeNotifier, fn conn ->
        Req.Test.text(conn, "received")
      end)

      assert {_req, %Req.Response{body: "received"}} = QuakeNotifier.dispatch_event(%Quake{}, "https://somedomain.com")
    end
  end
end
