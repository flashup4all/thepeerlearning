defmodule PeerLearning.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PeerLearningWeb.Telemetry,
      # Start the Ecto repository
      PeerLearning.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PeerLearning.PubSub},
      # Start Finch
      {Finch, name: PeerLearning.Finch},
      # Start the Endpoint (http/https)
      PeerLearningWeb.Endpoint,
      # Start Oban Jobs
      {Oban, Application.fetch_env!(:peer_learning, Oban)}
      # Start a worker by calling: PeerLearning.Worker.start_link(arg)
      # {PeerLearning.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PeerLearning.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PeerLearningWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
