defmodule Xcoin.Repo.Migrations.AddCurrentAmountType do
  use Ecto.Migration

  def up do
    execute """
    CREATE TYPE public.currency_amount AS (amount integer, currency varchar(3))
    """
  end

  def down do
    execute """
    DROP TYPE public.currency_amount
    """
  end
end
