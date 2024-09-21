defmodule Mix.Tasks.Quakes.Backfill do
  @moduledoc """
  This task backfills quakes for the past month.

  ## Usage

      mix quakes.backfill

  """
  @shortdoc "Backfills quakes for the past month."

  use Mix.Task

  def run(_args) do
    Mix.Task.run("app.start")
    quakes = Quakes.USGSApi.get_quakes_for_past_month()
    IO.puts "Backfilled #{Enum.count(quakes)} quakes"
  end
end
