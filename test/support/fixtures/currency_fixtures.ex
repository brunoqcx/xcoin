defmodule Xcoin.CurrencyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Xcoin.Currency` context.
  """

  @doc """
  Generate a exchange.
  """
  def exchange_fixture(attrs \\ %{}) do
    {:ok, exchange} =
      attrs
      |> Enum.into(%{
        start_currency: "USD",
        start_value: "100.0",
        end_currency: "JPY"
      })
      |> Xcoin.Currency.create_exchange()

    exchange
  end
end
