defmodule CoinRates.Repo do
  use Ecto.Repo,
    otp_app: :coin_rates,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    if (Application.get_env(:coin_rates, :app_env) != "dev") do
      config = config
      |> Keyword.put(:username, System.get_env("PGUSER"))
      |> Keyword.put(:password, System.get_env("PGPASSWORD"))
      |> Keyword.put(:database, System.get_env("PGDATABASE"))
      |> Keyword.put(:hostname, System.get_env("PGHOST"))
      |> Keyword.put(:port, System.get_env("PGPORT") |> String.to_integer)
    end
    {:ok, config}
  end
end
