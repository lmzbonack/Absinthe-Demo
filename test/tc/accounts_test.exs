defmodule Tc.AccountsTest do
  use TcWeb.ConnCase, async: true

  alias Tc.Accounts
  alias Tc.Accounts.User

  @valid_attrs %{email: "user1@email.com", name: "some name", password: "some password"}

  describe "create" do
    test "creates user" do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      assert user.name == "some name"
    end
  end

  describe "finds users" do
    test "finds user by email" do
      user = insert(:user, email: "lucfdaf@gmail.com")
      found = Accounts.get_user_by_email("lucfdaf@gmail.com")
      assert found.id == user.id
    end

    test "finds users by id" do
      user = insert(:user)
      found = Accounts.get_user!(user.id)
      assert found.id == user.id
    end
  end

  describe "changeset" do
    test "validates with correct attributes" do
      changeset = Accounts.change_user(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "does not validate with invalid data" do
      changeset =
        Accounts.change_user(
          %User{},
          Map.put(@valid_attrs, :email, "not.real")
        )

      refute changeset.valid?
    end
  end
end
