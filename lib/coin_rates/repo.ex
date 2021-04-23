defmodule CoinRates.Repo do
  use Ecto.Repo,
    otp_app: :coin_rates,
    adapter: Ecto.Adapters.Postgres
end
