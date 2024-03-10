defmodule Xcoin.CurrencyTest do
  use Xcoin.DataCase
  import Xcoin.AccountsFixtures

  alias Xcoin.Currency

  use Patch, only: [:patch], alias: [patch: :mock]

  describe "exchanges" do
    alias Xcoin.Currency.Exchange

    import Xcoin.CurrencyFixtures

    @invalid_attrs %{start_currency: nil, start_value: nil, end_currency: nil}

    test "list_exchanges/0 returns all exchanges" do
      mock(Currency.Rate, :get_value, fn(_a, _b) -> { :ok, Decimal.new("1.0") } end)

      user = user_fixture()
      exchange = exchange_fixture(user)
      assert Currency.list_exchanges(user) == [exchange]
    end

    test "get_exchange!/1 returns the exchange with given id" do
      mock(Currency.Rate, :get_value, fn(_a, _b) -> { :ok, Decimal.new("1.0") } end)

      user = user_fixture()
      exchange = exchange_fixture(user)
      assert Currency.get_exchange!(exchange.id) == exchange
    end

    test "create_exchange/1 with valid data creates a exchange" do
      mock(Currency.Rate, :get_value, fn(_a, _b) -> { :ok, Decimal.new("1.0") } end)

      user = user_fixture()

      valid_attrs = %{start_currency: "USD", start_value: "100.0", end_currency: "JPY"}

      assert {:ok, %Exchange{} = exchange} = Currency.create_exchange(user, valid_attrs)
      assert exchange.end_currency == "JPY"
      assert exchange.end_value == Decimal.new("100")
      assert exchange.rate == Decimal.new("1.0")
      assert exchange.start_currency == "USD"
      assert exchange.start_value == Decimal.new("100.00")
    end

    test "create_exchange/1 with invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} = Currency.create_exchange(user, @invalid_attrs)
    end
  end
end
