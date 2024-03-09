defmodule XcoinWeb.ExchangeController do
  use XcoinWeb, :controller

  alias Xcoin.Currency
  alias Xcoin.Currency.Exchange

  action_fallback XcoinWeb.FallbackController

  def index(conn, _params) do
    exchanges = Currency.list_exchanges()
    render(conn, :index, exchanges: exchanges)
  end

  def create(conn, %{"exchange" => exchange_params}) do
    with {:ok, %Exchange{} = exchange} <- Currency.create_exchange(exchange_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/exchanges/#{exchange}")
      |> render(:show, exchange: exchange)
    end
  end

  def show(conn, %{"id" => id}) do
    exchange = Currency.get_exchange!(id)
    render(conn, :show, exchange: exchange)
  end

  def update(conn, %{"id" => id, "exchange" => exchange_params}) do
    exchange = Currency.get_exchange!(id)

    with {:ok, %Exchange{} = exchange} <- Currency.update_exchange(exchange, exchange_params) do
      render(conn, :show, exchange: exchange)
    end
  end

  def delete(conn, %{"id" => id}) do
    exchange = Currency.get_exchange!(id)

    with {:ok, %Exchange{}} <- Currency.delete_exchange(exchange) do
      send_resp(conn, :no_content, "")
    end
  end
end
