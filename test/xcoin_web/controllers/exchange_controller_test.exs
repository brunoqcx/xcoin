defmodule XcoinWeb.ExchangeControllerTest do
  use XcoinWeb.ConnCase
  use Patch, only: [:patch], alias: [patch: :mock]

  import Xcoin.CurrencyFixtures

  alias Xcoin.Currency.Exchange
  import Xcoin.AccountsFixtures

  alias Xcoin.Accounts.User
  alias Xcoin.Accounts.Guardian

  @create_attrs %{
    end_currency: "JPY",
    end_value: "120.5",
    start_currency: "USD",
    start_value: "100.0"
  }

  @invalid_attrs %{rate: nil, start_currency: nil, start_value: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_session]

    test "lists all exchanges", %{conn: conn} do
      conn = get(conn, ~p"/api/exchanges")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create exchange" do
    setup [:create_session]

    test "renders exchange when data is valid", %{conn: conn} do
      mocked_api_exchange_response_body = ~s(
        {
          "success": true,
          "timestamp": 1710081423,
          "base": "USD",
          "date": "2024-03-10",
          "rates": {
              "JPY": 0.1
          }
        }
      )

      mocked_api_exchange_response = {:ok, %HTTPoison.Response{status_code: 200, body: mocked_api_exchange_response_body}}

      mock(HTTPoison, :get, fn(_a, _b, _c) -> mocked_api_exchange_response end)

      conn = post(conn, ~p"/api/exchanges", exchange: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/exchanges/#{id}")

      assert %{
              "id" => ^id,
              "end_currency" => "JPY",
              "end_value" => "10",
              "rate" => "0.1",
              "start_currency" => "USD",
              "start_value" => "100.00"
            } = json_response(conn, 200)["data"]
    end

    test "renders error when exchange api fails with 400", %{conn: conn} do
      mocked_api_exchange_response_body = ~s(
        {}
      )

      mocked_api_exchange_response = {:ok, %HTTPoison.Response{status_code: 400, body: mocked_api_exchange_response_body}}

      mock(HTTPoison, :get, fn(_a, _b, _c) -> mocked_api_exchange_response end)

      conn = post(conn, ~p"/api/exchanges", exchange: @create_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders error when exchange api fails", %{conn: conn} do
      mocked_api_exchange_response_body = ~s(
        {}
      )

      mocked_api_exchange_response = {:error, %HTTPoison.Error{reason: mocked_api_exchange_response_body}}

      mock(HTTPoison, :get, fn(_a, _b, _c) -> mocked_api_exchange_response end)

      conn = post(conn, ~p"/api/exchanges", exchange: @create_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/exchanges", exchange: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_session(%{conn: conn}) do
    user = user_fixture()
    conn = Guardian.Plug.sign_in(conn, user)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    %{conn: put_req_header(conn, "authorization", "Bearer #{token}"), user: user}
  end
end
