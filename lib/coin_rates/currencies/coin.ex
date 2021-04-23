defmodule CoinRates.Currencies.Coin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coins" do
    field :cmc_id, :integer
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(coin, attrs) do
    coin
    |> cast(attrs, [:name, :slug, :cmc_id])
    |> validate_required([:name, :slug, :cmc_id])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
    |> unique_constraint(:cmc_id)
  end
end
