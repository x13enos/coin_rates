defmodule CoinRates.Repo.Migrations.CreateUsersCoins do
  use Ecto.Migration

  def change do
    create table(:users_coins) do
      add :user_id, references(:users)
      add :coin_id, references(:coins)
    end

    create unique_index(:users_coins, [:user_id, :coin_id])
  end
end
