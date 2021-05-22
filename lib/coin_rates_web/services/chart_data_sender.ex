defmodule CoinRatesWeb.ChartDataSender do 
  import CoinRatesWeb.CoinsView, only: [convert_decimal: 1, convert_timestamp_to_unix: 1]

  def perform(slug, new_quote) do
    value = convert_decimal(new_quote.price)
    label = convert_timestamp_to_unix(new_quote.inserted_at)
    CoinRatesWeb.Endpoint.broadcast!("chart:#{slug}", "new_value", %{value: value, label: label})
  end

end