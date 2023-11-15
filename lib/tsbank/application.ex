defmodule Tsbank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ok = :telemetry.attach(
      # unique handler id
      "quantum-telemetry-metrics",
      [:phoenix, :request],
      &TsbankWeb.Telemetry.handle_event/4,
      nil
    )
    children = [

      {Tsbank.CounterServer, 0},
      Tsbank.PromEx,
      # Start the Telemetry supervisor
      TsbankWeb.Telemetry,
      # Start the Ecto repository
      Tsbank.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Tsbank.PubSub},
      # Start the Endpoint (http/https)
      TsbankWeb.Endpoint,
      # Start a worker by calling: Tsbank.Worker.start_link(arg)
      # {Tsbank.Worker, arg}
      BankSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tsbank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TsbankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
