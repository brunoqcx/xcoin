defmodule XcoinWeb.UserControllerTest do
  use XcoinWeb.ConnCase

  import Xcoin.AccountsFixtures

  alias Xcoin.Accounts.User
  alias Xcoin.Accounts.Guardian

  @create_attrs %{
    email: "some email",
    password: "some password"
  }
  @invalid_attrs %{email: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "index" do
  #   test "lists all users", %{conn: conn} do
  #     conn = get(conn, ~p"/api/users")
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  describe "create user" do
    setup [:create_session]

    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "login" do
    setup [:create_user]

    test "with valid credentials", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/login", %{
        email: user.email,
        password: "a password"
      })

      assert json_response(conn, 200)["data"]["id"] == user.id
    end

    test "with invalid credentials", %{conn: conn, user: user} do
      conn = post(conn, "/api/login", %{
        email: user.email,
        password: "wrong_password"
      })

      assert json_response(conn, 401)["error"] =~ "Invalid credentials"
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_session(%{conn: conn}) do
    user = user_fixture()
    conn = Guardian.Plug.sign_in(conn, user)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    %{conn: put_req_header(conn, "authorization", "Bearer #{token}"), user: user}
  end
end
