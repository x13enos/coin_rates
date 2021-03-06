defmodule CoinRates.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :crypted_password, :string
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    many_to_many :coins, CoinRates.Currencies.Coin, join_through: "users_coins", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
  end
end
