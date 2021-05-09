defmodule CoinRates.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :price, :decimal
      add :market_cap, :decimal
      add :volume_24h, :decimal
      add :percent_change_24h, :decimal
      add :coin_id, references(:coins, on_delete: :nothing)

      timestamps()
    end

    create index(:quotes, [:coin_id])
  end
end
