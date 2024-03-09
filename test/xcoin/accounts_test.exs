defmodule Xcoin.AccountsTest do
  use Xcoin.DataCase

  alias Xcoin.Accounts

  describe "users" do
    alias Xcoin.Accounts.User

    import Xcoin.AccountsFixtures

    @invalid_attrs %{email: nil, password: nil}

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).id == user.id
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "an email", password: "a password"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "an email"
      assert user.password == "a password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
