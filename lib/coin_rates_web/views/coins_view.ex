defmodule CoinRatesWeb.CoinsView do
  use CoinRatesWeb, :view

  def chat_logo(url) do
    cond do
      String.match?(url, ~r/t.me/) -> "telegram"
      String.match?(url, ~r/discord.gg/) -> "discord"
      true -> "comment"
    end
  end
end
