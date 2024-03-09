defmodule XcoinWeb.UserController do
  use XcoinWeb, :controller

  alias Xcoin.Accounts
  alias Xcoin.Accounts.User
  alias Xcoin.Accounts.Guardian

  action_fallback XcoinWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end
end
