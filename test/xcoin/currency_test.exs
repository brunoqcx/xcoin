defmodule Xcoin.CurrencyTest do
  use Xcoin.DataCase

  alias Xcoin.Currency

  describe "exchanges" do
    alias Xcoin.Currency.Exchange

    import Xcoin.CurrencyFixtures

    @invalid_attrs %{start_currency: nil, start_value: nil, end_currency: nil}

    test "list_exchanges/0 returns all exchanges" do
      exchange = exchange_fixture()
      assert Currency.list_exchanges() == [exchange]
    end

    test "get_exchange!/1 returns the exchange with given id" do
      exchange = exchange_fixture()
      assert Currency.get_exchange!(exchange.id) == exchange
    end

    test "create_exchange/1 with valid data creates a exchange" do
      valid_attrs = %{start_currency: "USD", start_value: "100.0", end_currency: "JPY"}

      assert {:ok, %Exchange{} = exchange} = Currency.create_exchange(valid_attrs)
      assert exchange.end_currency == "JPY"
      assert exchange.end_value == nil
      assert exchange.rate == nil
      assert exchange.start_currency == "USD"
      assert exchange.start_value == Decimal.new("100.0")
    end

    test "create_exchange/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Currency.create_exchange(@invalid_attrs)
    end

    test "change_exchange/1 returns a exchange changeset" do
      exchange = exchange_fixture()
      assert %Ecto.Changeset{} = Currency.change_exchange(exchange)
    end
  end
end
