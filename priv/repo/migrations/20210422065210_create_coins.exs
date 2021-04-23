defmodule CoinRates.Repo.Migrations.CreateCoins do
  use Ecto.Migration

  def change do
    create table(:coins) do
      add :name, :string
      add :slug, :string
      add :cmc_id, :integer

      timestamps()
    end

    create unique_index(:coins, [:name])
    create unique_index(:coins, [:slug])
    create unique_index(:coins, [:cmc_id])
  end
end
