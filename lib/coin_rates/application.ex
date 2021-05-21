defmodule CoinRates.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CoinRates.Repo,
      # Start the Telemetry supervisor
      CoinRatesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CoinRates.PubSub},
      # Start the Endpoint (http/https)
      CoinRates.QuotesFetchingJob,
      # Start repeated job of fetching prices
      CoinRatesWeb.Endpoint
      # Start a worker by calling: CoinRates.Worker.start_link(arg)
      # {CoinRates.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CoinRates.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CoinRatesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
