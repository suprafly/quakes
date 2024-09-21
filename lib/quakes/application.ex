defmodule Quakes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      QuakesWeb.Telemetry,
      Quakes.Repo,
      {DNSCluster, query: Application.get_env(:quakes, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Quakes.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Quakes.Finch},
      # Start a worker by calling: Quakes.Worker.start_link(arg)
      # {Quakes.Worker, arg},
      # Start to serve requests, typically the last entry
      QuakesWeb.Endpoint,
      {Quakes.QuakeMonitor, []}
    ]

    # Create an ETS table to hold subscriptions in memory
    # Setting this as public for now because it is simpler,
    # and in the next step we will throw this away anyway
    # and move to a db.
    :ets.new(:subscriptions, [:set, :public, :named_table])

    opts = [strategy: :one_for_one, name: Quakes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QuakesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
