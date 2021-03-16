defmodule NeosSocket.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      NeosSocket.Repo,
      # Start the Telemetry supervisor
      NeosSocketWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: NeosSocket.PubSub},
      # Start the Endpoint (http/https)
      NeosSocketWeb.Endpoint
      # Start a worker by calling: NeosSocket.Worker.start_link(arg)
      # {NeosSocket.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NeosSocket.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NeosSocketWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
