defmodule CoinRatesWeb.CoinsView do
  use CoinRatesWeb, :view

  def chat_logo(url) do
    cond do
      String.match?(url, ~r/t.me/) -> "telegram"
      String.match?(url, ~r/discord.gg/) -> "discord"
      true -> "comment"
    end
  end

  def select_quotes_timestamp(quotes) do
    Enum.map(quotes, & convert_timestamp_to_unix(&1.inserted_at))
  end

  def select_quotes_price(quotes) do
    Enum.map(quotes, & convert_decimal(&1.price))
  end

  def convert_decimal(value) do
    :erlang.float_to_binary(Decimal.to_float(value), [:compact, decimals: 20])
  end

  def convert_timestamp_to_unix(value) do
    seconds = NaiveDateTime.to_gregorian_seconds(value) |> elem(0)
    seconds * 1000
  end
end
