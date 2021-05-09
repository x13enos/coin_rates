defmodule CoinRates.PriceFetchingJob do
  use GenServer
  
  @impl true
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end
  
  @impl true
  def init(state) do
    :timer.send_interval(300_000, :work)
    {:ok, state}
  end
  
  @impl true
  def handle_info(:work, state) do
    do_recurrent_thing()
    {:noreply, state}
  end
  
  defp do_recurrent_thing() do
    CoinRatesWeb.PriceFetcher.perform()
  end
end