defmodule CoinRates.Currencies.Quote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotes" do
    field :market_cap, :decimal
    field :percent_change_24h, :decimal
    field :price, :decimal
    field :volume_24h, :decimal
    belongs_to :coin, CoinRates.Currencies.Coin

    timestamps()
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:price, :market_cap, :volume_24h, :percent_change_24h, :coin_id])
    |> assoc_constraint(:coin)
    |> validate_required([:price, :market_cap, :volume_24h, :percent_change_24h])
  end
end
