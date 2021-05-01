defmodule CoinRates.Currencies.Coin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coins" do
    field :cmc_id, :integer
    field :name, :string
    field :slug, :string
    field :logo, :string
    field :reddit, :string
    field :website, :string
    field :twitter, :string
    field :chats, {:array, :string}
    field :token_address, :string

    timestamps()
  end

  @doc false
  def changeset(coin, attrs) do
    coin
    |> cast(attrs, [:name, :slug, :cmc_id, :logo, :reddit, :twitter, :website, :token_address, :chats])
    |> validate_required([:name, :slug, :cmc_id])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
    |> unique_constraint(:cmc_id)
    |> unique_constraint(:token_address)
  end
end
