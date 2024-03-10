defmodule XcoinWeb.ExchangeController do
  use XcoinWeb, :controller

  alias Xcoin.Currency
  alias Xcoin.Currency.Exchange
  alias Xcoin.Accounts.Guardian

  action_fallback XcoinWeb.FallbackController

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    exchanges = Currency.list_exchanges(user)
    render(conn, :index, exchanges: exchanges)
  end

  def create(conn, %{"exchange" => exchange_params}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, %Exchange{} = exchange} <- Currency.create_exchange(user, exchange_params) do
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
end
