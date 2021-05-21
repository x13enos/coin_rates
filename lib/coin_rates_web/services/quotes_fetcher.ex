defmodule CoinRatesWeb.QuotesFetcher do 
  @moduledoc """
  Price fetcher.
  """

  @doc """
  It launches service, that gets all added coins from db and fetches last quotes for them.

  ## Examples

      iex> perform()
      {:ok}

  """

  def perform do
    coins = CoinRates.Currencies.list_coins
    fetch_data_from_market(coins) |>
    create_quotes(coins)
    {:ok}
  end

  defp fetch_data_from_market(coins) do
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?id=#{joined_ids_to_param(coins)}"
    headers = ["X-CMC_PRO_API_KEY": Application.get_env(:coin_rates, :coinmarketcap_key)]
    HTTPoison.get(url, headers)
  end

  defp create_quotes({:ok, response}, coins) do
    Enum.each(coins, fn coin -> 
      {:ok, new_quote} = select_params(response, coin) |> CoinRates.Currencies.create_quote()
      spawn(CoinRatesWeb.ChartDataSender, :perform, [coin.slug, new_quote])
    end)
  end

  defp joined_ids_to_param(coins) do
    coins
    |> Enum.map(fn coin -> coin.cmc_id end)
    |> Enum.join(",")
  end

  defp select_params(response, coin) do
    data = Poison.decode!(response.body)["data"]
    item_data = data |> Map.values |> Enum.find(fn q -> q["id"] == coin.cmc_id end) 
    quote_data = item_data["quote"]["USD"]
    %{
      "coin_id" => coin.id,
      "market_cap" => quote_data["market_cap"],
      "percent_change_24h" => quote_data["percent_change_24h"],
      "price" => quote_data["price"],
      "volume_24h" => quote_data["volume_24h"]
    }
  end
end
