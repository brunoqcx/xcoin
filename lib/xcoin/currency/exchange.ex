defmodule Xcoin.Currency.Exchange do
  use Ecto.Schema
  import Ecto.Changeset

  schema "exchanges" do
    field :end_currency, :string
    field :end_value, :decimal
    field :rate, :decimal
    field :start_currency, :string
    field :start_value, :decimal
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exchange, attrs) do
    exchange
    |> cast(attrs, [:start_value, :start_currency, :end_currency])
    |> validate_required([:start_value, :start_currency, :end_currency])
  end
end
