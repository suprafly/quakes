defmodule Quakes.QuakeMonitor do
  @moduledoc """
  `QuakeMonitor` is a Genserver that handles polling the USGS Api,
  saving results, and dispatching webhook events.
  """

  use GenServer
  use QuakesWeb, :verified_routes

  alias Quakes.USGSApi
  alias Quakes.QuakeNotifier

  @doc"""
  Get the endpoint for our local webhook listener.
  """
  def target_self, do: url(~p"/listen/quakes/")

  @doc"""
  Convert ms to seconds.
  """
  def in_seconds(num_secs), do: num_secs * 1000

  def start_link(_opts) do
    state =
      %{
        schedule_work: [
          {:get_latest_quakes, [
            frequency: {:every, in_seconds(60)}
            ]
          },
        ],
        get_latest_quakes: %{
          quakes: [],
          subscribers: [target_self()]
        }
      }
    GenServer.start_link(__MODULE__, state)
  end

  def init(%{schedule_work: tasks} = state) do
    schedule_tasks(tasks)
    {:ok, state}
  end

  def handle_info({:get_latest_quakes, _} = task, state) do
    %{quakes: quakes_list, subscribers: subscribers} = state.get_latest_quakes

    quakes = USGSApi.get_quakes()
    sorted_new_quakes = take_only_new(quakes, quakes_list)

    # Dispatch webhook events for all quakes in `sorted_new_quakes`
    dispatch_quakes_to_subscribers(sorted_new_quakes, subscribers)

    # Reschedule the task
    schedule_task(task)

    task_state = %{quakes: sorted_new_quakes ++ quakes_list, subscribers: subscribers}

    {:noreply, %{state | get_latest_quakes: task_state}}
  end

  defp dispatch_quakes_to_subscribers(sorted_new_quakes, subscribers) do
    Enum.each(sorted_new_quakes, &dispatch_to_subscribers(&1, subscribers))
  end

  defp dispatch_to_subscribers(quake, subscribers) do
    Enum.each(subscribers, fn subscriber ->
      Task.start(fn -> QuakeNotifier.dispatch_event(quake, subscriber) end)
    end)
  end

  defp schedule_task({task, frequency}) do
    Process.send_after(self(), {task, frequency}, frequency)
  end

  defp schedule_tasks(tasks) do
    Enum.map(tasks, fn {task, opts} ->
      case Keyword.get(opts, :frequency) do
        {:every, frequency} ->
          # Schedule the first right away, then get them on track
          Process.send_after(self(), {task, frequency}, in_seconds(1))

        _ ->
          raise "#{__MODULE__} error - unimplemented frequency option"
      end
    end)
  end

  def take_only_new(quake_list, previous_quake_list) do
    previous_quake_ids = Enum.map(previous_quake_list, & &1.id)
    quake_list
    |> Enum.sort_by(& &1.properties.time)
    |> Enum.reject(fn quake -> quake.id in previous_quake_ids end)
  end
end
