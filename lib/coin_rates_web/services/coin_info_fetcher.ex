defmodule CoinRatesWeb.CoinInfoFetcher do 
  @moduledoc """
  Coin Info fetcher.
  """

  @doc """
  It launches service, that uses passed slug for fetching coin's info from CoinMarkerCap.

  ## Examples

      iex> perform('OKTA')
      {:ok}

  """

  def perform(slug, current_user) do
    {:ok, response} = fetch_data_from_market(slug)
    handle_response(response, current_user)
  end

  defp fetch_data_from_market(slug) do
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?slug=#{String.downcase(slug)}"
    headers = ["X-CMC_PRO_API_KEY": Application.get_env(:coin_rates, :coinmarketcap_key)]
    HTTPoison.get(url, headers)
  end

  defp handle_response(%{ status_code: 400 }), do: {:error, "You passed invalid slug"}
  defp handle_response(response, current_user) do
    {:ok, coin} = Poison.decode!(response.body)
    |> select_params
    |> create_coin
    CoinRates.Accounts.add_coin(current_user, coin)
    {:ok}
  end

  defp select_params(body) do
    coin_data = body["data"] |> Map.values |> List.first
    %{
      "cmc_id" => coin_data["id"],
      "name" => coin_data["name"],
      "slug" => coin_data["slug"],
      "logo" => coin_data["logo"],
      "reddit" => coin_data["urls"]["reddit"] |> List.first,
      "twitter" => coin_data["urls"]["twitter"] |> List.first,
      "website" => coin_data["urls"]["website"] |> List.first,
      "chats" => coin_data["urls"]["chat"],
      "token_address" => coin_data["platform"]["token_address"]
    }
  end

  defp create_coin(coin_params) do
    CoinRates.Currencies.create_coin(coin_params)
  end
end
