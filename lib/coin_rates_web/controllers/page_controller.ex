defmodule CoinRatesWeb.PageController do
  use CoinRatesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
