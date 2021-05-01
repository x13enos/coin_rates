defmodule CoinRatesWeb.CoinsController do
  use CoinRatesWeb, :controller

  alias CoinRates.Currencies

  def index(conn, _params) do
    coins = Currencies.list_coins()
    render(conn, "index.html", coins: coins)
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    %{ "coin" => %{ "slug" => slug } } = params
    cond do
      String.trim(slug) == "" ->
        return_error(conn, "new.html", "You should send the slug.")
      coin_already_exists?(slug) ->
        return_error(conn, "new.html", "This coin already exists.")
      true -> case CoinRatesWeb.CoinInfoFetcher.perform(slug) do
        {:ok} -> redirect(conn, to: Routes.coins_path(conn, :index))
        {:error, message} -> return_error(conn, "new.html", message)
      end
    end
  end

  defp return_error(conn, template, message) do
    conn
    |> put_flash(:error, message)
    |> render(template)
  end

  defp coin_already_exists?(slug) do
    Currencies.get_coin_by(%{slug: slug})
  end
end
