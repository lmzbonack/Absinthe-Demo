defmodule Tc.BooksTest do
  use TcWeb.ConnCase, async: true

  alias Tc.Books
  alias Tc.Books.Book

  @valid_attrs %{name: "Book name"}

  describe "create" do
    test "creates book" do
      library = insert(:library)

      {:ok, book} =
        @valid_attrs
        |> Enum.into(%{library_id: library.id})
        |> Books.create_book()

      assert book.name == "Book name"
    end
  end

  describe "edit" do
    test "edits book" do
      book = insert(:book)

      {:ok, updated_book} = Books.update_book(book, %{checked_out: true})

      assert updated_book.checked_out == true
      assert book.id == updated_book.id
    end
  end

  describe "finds book" do
    test "finds list of books" do
      insert(:book)
      insert(:book)

      books = Books.list_books()

      assert Enum.count(books) == 2
    end

    test "finds single library" do
      book_one = insert(:book)

      book = Books.get_book!(book_one.id)

      assert book.id == book_one.id
    end
  end

  describe "changest" do
    test "validates with correct changeset" do
      library = insert(:library)

      changeset = Tc.Books.change_book(%Book{}, @valid_attrs |> Enum.into(%{library_id: library.id}))
      assert changeset.valid?
    end

    test "does not validate when wrong" do
      changeset = Tc.Books.change_book(%Book{}, %{})
      refute changeset.valid?
    end
  end
end
