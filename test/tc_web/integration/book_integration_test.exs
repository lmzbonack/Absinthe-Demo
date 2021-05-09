defmodule Tc.Integration.BookIntegrationTest do
  use TcWeb.ConnCase, async: true
  alias Tc.AbsintheHelpers

  describe "lists books" do
    test "returns list of books" do
      insert(:book)
      insert(:book)

      query = """
      {
        books {
          id
          name
          checked_out
        }
      }
      """

      res =
        build_conn()
        |> post("/", AbsintheHelpers.query_skeleton(query, "books"))

      books = json_response(res, 200)["data"]["books"]
      assert Enum.count(books) == 2
    end
  end

  describe "show" do
    test "returns a single book" do
      book = insert(:book)

      query = """
      {
        book(id: "#{book.id}") {
          id
          name
          checked_out
        }
      }
      """

      res =
        build_conn()
        |> post("/", AbsintheHelpers.query_skeleton(query, "book"))

      found_book = json_response(res, 200)["data"]["book"]
      assert found_book["id"] == to_string(book.id)
    end
  end

  describe "create" do
    test "creates book" do
      user = insert(:user)
      library = insert(:library)

      mutation = """
      {
        createBook(name: "Inferno", library_id: "#{library.id}") {
          name
          libraryId
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/", AbsintheHelpers.mutation_skeleton(mutation))

      book = json_response(res, 200)["data"]["createBook"]
      assert book["name"] == "Inferno"
      assert book["libraryId"] == library.id
    end
  end

  describe "edit" do
    test "edits book" do
      user = insert(:user)
      book = insert(:book)

      # Creates in checked out status with nil user
      assert book.user_id == nil
      assert book.checked_out == false

      mutation = """
      {
        editBook(checkedOut: true, id: "#{book.id}") {
          checkedOut
          user {
            id
          }
        }
      }
      """

      res =
        build_conn()
        |> AbsintheHelpers.authenticate_conn(user)
        |> post("/", AbsintheHelpers.mutation_skeleton(mutation))

      book = json_response(res, 200)["data"]["editBook"]
      assert book["user"]["id"] == user.id
      assert book["checkedOut"] == true
    end
  end
end
