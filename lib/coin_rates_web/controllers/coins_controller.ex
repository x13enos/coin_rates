defmodule CoinRatesWeb.CoinsController do
  use CoinRatesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    %{ "coin" => %{ "slug" => slug } } = params
    if String.trim(slug) != "" do
      case CoinRatesWeb.CoinInfoFetcher.perform(slug) do
        {:ok} -> render(conn, "new.html")
        {:error, message} -> return_error(conn, "new.html", message)
      end
    else
      return_error(conn, "new.html", "You should send the slug.")
    end
  end

  defp return_error(conn, template, message) do
    conn
    |> put_flash(:error, message)
    |> render(template)
  end
end
