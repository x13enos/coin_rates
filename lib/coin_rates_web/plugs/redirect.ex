defmodule CoinRatesWeb.Plugs.Redirect do
  import Plug.Conn

  def init(opts) do
    if Keyword.has_key?(opts, :to) do
      opts
    else
      raise("Missing required option ':to' in redirect")
    end
  end

  def call(%Plug.Conn{} = conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
  end
end