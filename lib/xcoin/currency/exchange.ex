defmodule Xcoin.Currency.Exchange do
  use Ecto.Schema
  import Ecto.Changeset
  alias Xcoin.Currency.Rate

  @valid_currencies ["USD", "EUR", "BRL", "JPY"]

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
    |> validate_required([:start_value, :start_currency, :end_currency, :user_id])
    |> validate_inclusion(:start_currency, @valid_currencies)
    |> validate_inclusion(:end_currency, @valid_currencies)
    |> convert_values
    |> validate_required([:end_value, :rate])
  end

  defp convert_values(cs) do
    case { cs.valid? } do
      { false } -> cs
      { true } ->
        { start_value, rate, end_value } = calculate(cs.changes[:start_value], cs.changes[:start_currency], cs.changes[:end_currency])

        if rate do
          cs
          |> put_change(:start_value, start_value)
          |> put_change(:end_value, end_value)
          |> put_change(:rate, rate)
        else
          cs
        end
    end
  end

  defp calculate(start_value, start_currency, end_currency) do
    start_currency = String.to_atom(start_currency)
    end_currency = String.to_atom(end_currency)
    start_money = Money.new(start_currency, start_value)

    rate = Rate.get_value(start_currency, end_currency)
    case rate do
      { :ok, value } ->
        { :ok, end_money } = Money.to_currency(start_money, end_currency, %{ start_currency =>  Decimal.new("1.0"), end_currency => value})

        rounded_start_value  = Money.to_decimal(Money.round(start_money))
        rounded_end_value  = Money.to_decimal(Money.round(end_money))

        { rounded_start_value, value, rounded_end_value }
      { :error, _value } ->
        { nil, nil, nil }
    end
  end
end
