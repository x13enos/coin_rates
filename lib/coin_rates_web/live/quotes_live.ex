defmodule CoinRatesWeb.QuotesLive do
  # use CoinRatesWeb, :live_view

  # def render(assigns) do
  #   ~L"""
  #   <%= if assigns[:price] do %>
  #   Current price: <%= @price %>
  #   <% end %>
  #   """
  # end

  # def mount(params, data, socket) do
  #   if connected?(socket) do 
  #     Process.send_after(self(), :update, 5000)
  #     coins = CoinRates.Currencies.last_quote()
  #     {:ok, assign(socket, :price, Enum.random(0..10))}
  #   else
  #     {:ok, socket}
  #   end
  # end

  # def handle_info(:update, socket) do
  #   Process.send_after(self(), :update, 5000)
  #   quote = CoinRates.Currencies.last_quote()
  #   {:noreply, assign(socket, :price, Enum.random(0..10))}
  # end
end