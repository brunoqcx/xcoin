defmodule XcoinWeb.ExchangeJSON do
  alias Xcoin.Currency.Exchange

  @doc """
  Renders a list of exchanges.
  """
  def index(%{exchanges: exchanges}) do
    %{data: for(exchange <- exchanges, do: data(exchange))}
  end

  @doc """
  Renders a single exchange.
  """
  def show(%{exchange: exchange}) do
    %{data: data(exchange)}
  end

  defp data(%Exchange{} = exchange) do
    %{
      id: exchange.id,
      user_id: exchange.user_id,
      start_value: exchange.start_value,
      start_currency: exchange.start_currency,
      end_value: exchange.end_value,
      end_currency: exchange.end_currency,
      rate: exchange.rate,
      creation_time: exchange.inserted_at
    }
  end
end
