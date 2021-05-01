defmodule CoinRates.Repo.Migrations.CreateCoins do
  use Ecto.Migration

  def change do
    create table(:coins) do
      add :name, :string
      add :slug, :string
      add :logo, :string
      add :reddit, :string
      add :website, :string
      add :twitter, :string
      add :chats, {:array, :string}
      add :cmc_id, :integer
      add :token_address, :string

      timestamps()
    end

    create unique_index(:coins, [:name])
    create unique_index(:coins, [:slug])
    create unique_index(:coins, [:cmc_id])
    create unique_index(:coins, [:token_address])
  end
end
