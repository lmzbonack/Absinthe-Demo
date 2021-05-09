defmodule Tc.Integration.UserIntegrationTest do
  use TcWeb.ConnCase, async: true
  alias Tc.AbsintheHelpers

  describe "current_user" do
    test "returns current user" do
      user = insert(:user)

      query = """
      {
        currentUser {
          id
          name
          email
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/", AbsintheHelpers.query_skeleton(query, "currentUser"))

      current_user = json_response(res, 200)["data"]["currentUser"]
      assert current_user["id"] == to_string(user.id)
    end
  end

  describe "authenticate" do
    test "authenticates user" do
      user = insert(:user, password: "password")

      mutation = """
      {
        authenticate(email: "#{user.email}", password: "password") {
          id
        }
      }
      """

      res =
        build_conn()
        |> post("/", AbsintheHelpers.mutation_skeleton(mutation))

      authenticate = json_response(res, 200)["data"]["authenticate"]
      assert authenticate["id"] == to_string(user.id)
    end
  end


  describe "sign_up" do
    test "signs up user" do
      mutation = """
      {
        signUp(name: "Luc Zbonack", email: "luc@gmail.com", password: "p@ssword") {
          name
          email
        }
      }
      """

      res =
        build_conn()
        |> post("/", AbsintheHelpers.mutation_skeleton(mutation))

      user = json_response(res, 200)["data"]["signUp"]
      assert user["name"] == "Luc Zbonack"
      assert user["email"] == "luc@gmail.com"
    end
  end
end
