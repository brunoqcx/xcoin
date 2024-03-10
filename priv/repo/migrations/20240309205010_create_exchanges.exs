defmodule Xcoin.Repo.Migrations.CreateExchanges do
  use Ecto.Migration

  def change do
    create table(:exchanges) do
      add :start_value, :decimal
      add :start_currency, :string
      add :end_value, :decimal
      add :end_currency, :string
      add :rate, :decimal
      add :user_id, references(:users, on_delete: :restrict)

      timestamps(type: :utc_datetime)
    end

    create index(:exchanges, [:user_id])
  end
end
