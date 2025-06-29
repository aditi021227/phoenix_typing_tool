defmodule PhoenixTypingTool.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixTypingToolWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:phoenix_typing_tool, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixTypingTool.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixTypingTool.Finch},
      # Start a worker by calling: PhoenixTypingTool.Worker.start_link(arg)
      # {PhoenixTypingTool.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixTypingToolWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixTypingTool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixTypingToolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
