defmodule Xcoin.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Xcoin.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "an email",
        password: "a password"
      })
      |> Xcoin.Accounts.create_user()

    user
  end
end
