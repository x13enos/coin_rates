defmodule CoinRatesWeb.CoinsController do
  use CoinRatesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    %{ "coin" => %{ "url" => url } } = params
    if String.trim(url) != "" do
      IO.puts url
      render(conn, "new.html")
    else
      conn
      |> put_flash(:error, "You should send the url.")
      |> render("new.html")
    end
  end
end
