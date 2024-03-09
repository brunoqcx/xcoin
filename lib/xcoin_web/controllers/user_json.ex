defmodule XcoinWeb.UserJSON do
  alias Xcoin.Accounts.User

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  def create(%{user: user, token: token}) do
    %{data: data(user, token)}
  end


  defp data(%User{} = user, token) do
    %{
      id: user.id,
      email: user.email,
      token: token
    }
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
