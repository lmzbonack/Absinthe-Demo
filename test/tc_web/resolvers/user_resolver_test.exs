defmodule TcWeb.UserResolverTest do
  use TcWeb.ConnCase, async: true

  alias TcWeb.Resolvers.UserResolver

  describe "current_user information retrieval" do
    test "returns the current user" do
      current_user = insert(:user)

      {:ok, found} =
        UserResolver.current_user(nil, nil, %{
          context: %{current_user: current_user}
        })

      assert found.id == current_user.id
    end

    test "returns error for unauthenticated user" do
      {:error, error} = UserResolver.current_user(nil, nil, nil)

      assert error == "Unauthenticated"
    end
  end

  describe "register" do
    test "creates user on valid signup" do
      {:ok, user} =
        UserResolver.signup(
          nil,
          %{name: "Luc Zbonack", email: "luc@gmail.com", password: "p@ssword"},
          nil
        )

      assert user.name == "Luc Zbonack"
      assert user.email == "luc@gmail.com"
    end

    test "returns error for missing name param" do
      {:error, error} =
        UserResolver.signup(
          nil,
          %{email: "luc@gmail.com", password: "p@ssword"},
          nil
        )

      assert error == [[field: :name, message: "Can't be blank"]]
    end
  end

  describe "authenticate" do
    test "returns user on valid credentials" do
      user = insert(:user, email: "luc@gmail.com", password: "password")

      {:ok, found} =
        UserResolver.authenticate(
          nil,
          %{email: "luc@gmail.com", password: "password"},
          nil
        )

      assert found.id == user.id
    end

    test "returns error for nonexistend user" do
      {:error, error} =
        UserResolver.authenticate(
          nil,
          %{email: "luc@gmail.com", password: "p@ssword"},
          nil
        )

      assert error == [[field: :email, message: "Invalid email or password"]]
    end

    test "returns error for invalid credentials" do
      insert(:user, email: "luc@gmail.com", password: "p@ssword")

      {:error, error} =
        UserResolver.authenticate(
          nil,
          %{email: "luc@gmail.com", password: "wrong"},
          nil
        )

      assert error == [[field: :email, message: "Invalid email or password"]]
    end
  end
end
