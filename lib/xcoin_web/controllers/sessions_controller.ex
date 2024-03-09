defmodule XcoinWeb.SessionController do
  use XcoinWeb, :controller

  action_fallback XcoinWeb.FallbackController

  alias Xcoin.{Accounts, Accounts.Guardian}

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user)
        conn
        |> put_status(:ok)
        |> render(:user_token, user: user, token: token)
      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  @spec logout(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_status(:ok)
    |> json(%{msg: "Logged out"})
  end
end
