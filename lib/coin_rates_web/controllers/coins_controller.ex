defmodule CoinRatesWeb.CoinsController do
  use CoinRatesWeb, :controller

  alias CoinRates.Currencies

  def index(conn, _params) do
    coins = Currencies.user_coins(conn.assigns.current_user.id)
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
      coin = coin_already_exists?(slug) ->
        process_existed_coin(conn, coin)
      true -> case CoinRatesWeb.CoinInfoFetcher.perform(slug, conn.assigns.current_user) do
        {:ok} -> redirect(conn, to: Routes.coins_path(conn, :index))
        {:error, message} -> return_error(conn, "new.html", message)
      end
    end
  end

  def delete(conn, %{ "id" => coin_id }) do
    coin = Currencies.get_coin!(coin_id)
    CoinRates.Accounts.remove_coin(conn.assigns.current_user, coin)
    conn
    |>put_flash(:info, "You succesfully removed coin!")
    |>redirect(to: Routes.coins_path(conn, :index))
  end

  defp return_error(conn, template, message) do
    conn
    |> put_flash(:error, message)
    |> render(template)
  end

  defp coin_already_exists?(slug) do
    Currencies.get_coin_by(%{slug: slug})
  end

  defp process_existed_coin(conn, coin) do
    cond do
      Currencies.user_coin(conn.assigns.current_user.id, coin.id) |> length != 0 ->
        return_error(conn, "new.html", "You already trace this coin")
      true ->
        CoinRates.Accounts.add_coin(conn.assigns.current_user, coin)
        conn
        |>put_flash(:info, "You have started trace this coin")
        |>redirect(to: Routes.coins_path(conn, :index))
    end
  end
end
