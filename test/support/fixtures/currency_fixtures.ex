defmodule Xcoin.CurrencyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Xcoin.Currency` context.
  """

  @doc """
  Generate a exchange.
  """
  def exchange_fixture(user, attrs \\ %{}) do
    attrs =
      attrs
      |> Enum.into(%{
        start_currency: "USD",
        start_value: "100.0",
        end_currency: "JPY"
      })

    {:ok, exchange } = Xcoin.Currency.create_exchange(user, attrs)

    exchange
  end
end
