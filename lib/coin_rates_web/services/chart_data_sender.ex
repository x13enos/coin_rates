defmodule CoinRatesWeb.ChartDataSender do 

  def perform(slug, new_quote) do
    value = convert_decimal(new_quote.price)
    label = convert_timestamp_to_unix(new_quote.inserted_at)
    CoinRatesWeb.Endpoint.broadcast!("chart:#{slug}", "new_value", %{value: value, label: label})
  end

  defp convert_decimal(value) do
    :erlang.float_to_binary(Decimal.to_float(value), [:compact, decimals: 20])
  end

  defp convert_timestamp_to_unix(value) do
    seconds = NaiveDateTime.to_gregorian_seconds(value) |> elem(0)
    seconds * 1000
  end

end