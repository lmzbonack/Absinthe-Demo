defmodule Tc.Integration.LibraryIntegrationTest do
  use TcWeb.ConnCase, async: true
  alias Tc.AbsintheHelpers

  describe "lists libraries" do
    test "returns list of libraries" do
      insert(:library)
      insert(:library)

      query = """
      {
        libraries {
          id
          name
          address
        }
      }
      """

      res =
        build_conn()
        |> post("/", AbsintheHelpers.query_skeleton(query, "libraries"))

      libraries = json_response(res, 200)["data"]["libraries"]
      assert Enum.count(libraries) == 2
    end
  end

  describe "show" do
    test "returns a single library" do
      library = insert(:library)

      query = """
      {
        library(id: "#{library.id}") {
          id
          name
          address
        }
      }
      """

      res =
        build_conn()
        |> post("/", AbsintheHelpers.query_skeleton(query, "library"))

      found_lib = json_response(res, 200)["data"]["library"]
      assert found_lib["id"] == to_string(library.id)
    end
  end

  describe "create" do
    test "creates library" do
      user = insert(:user)

      mutation = """
      {
        createLibrary(name: "Another library", address: "New address") {
          name
          address
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/", AbsintheHelpers.mutation_skeleton(mutation))

      library = json_response(res, 200)["data"]["createLibrary"]
      assert library["name"] == "Another library"
      assert library["address"] == "New address"
    end
  end
end
