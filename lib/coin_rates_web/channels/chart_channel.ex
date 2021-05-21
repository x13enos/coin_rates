defmodule CoinRatesWeb.ChartChannel do
  use Phoenix.Channel

  def join("chart:" <> chart_slug, _message, socket) do
    {:ok, socket}
  end

end