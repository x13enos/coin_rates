defmodule CoinRatesWeb.CoinInfoFetcher do
  alias CoinRates.Currencies

  def perform(slug) do
    {:ok, response} = fetch_data_from_market(slug)
    handle_response(response)
  end

  defp fetch_data_from_market(slug) do
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?slug=#{String.downcase(slug)}"
    headers = ["X-CMC_PRO_API_KEY": "token"]
    HTTPoison.get(url, headers)
  end

  defp handle_response(%{ status_code: 400 }), do: {:error, "You passed invalid slug"}
  defp handle_response(response) do
    {:ok}
  end
end
