defmodule TcWeb.BookResolverTest do
  use TcWeb.ConnCase, async: true

  alias TcWeb.Resolvers.BookResolver

  describe "list" do
    test "returns books" do
      insert(:book)
      insert(:book)

      {:ok, results} = BookResolver.list(nil, nil, nil)
      assert length(results) == 2
    end
  end

  describe "show" do
    test "returns specific book" do
      book = insert(:book)
      {:ok, found} = BookResolver.show(nil, %{id: book.id}, nil)
      assert found.id == book.id
    end

    test "returns not found when book does not exist" do
      {:error, error} = BookResolver.show(nil, %{id: 1}, nil)
      assert error == "Not found"
    end
  end

  describe "create" do
    test "creates valid book with authenticated user" do
      user = insert(:user)
      library = insert(:library)

      {:ok, book} =
        BookResolver.create(nil, %{name: "Of Mice and Men", library_id: library.id}, %{
          context: %{current_user: user}
        })

      assert book.name == "Of Mice and Men"
      assert book.library_id == library.id
    end

    test "returns error for missing params" do
      user = insert(:user)

      {:error, error} =
        BookResolver.create(nil, %{name: "Of Mice and Men"}, %{
          context: %{current_user: user}
        })

      assert error == [[field: :library_id, message: "Can't be blank"]]
    end

    test "returns error for unauthenticated user" do
      library = insert(:library)

      {:error, error} =
        BookResolver.create(nil, %{name: "Of Mice and Men", library_id: library.id}, nil)

      assert error == "Unauthenticated"
    end
  end

  describe "edit" do
    test "edits the checked_out status with authenticated user" do
      user = insert(:user)
      book = insert(:book)

      # Creates in checked out status with nil user
      assert book.user_id == nil
      assert book.checked_out == false

      {:ok, updated_book} = BookResolver.update(nil, %{id: book.id, checked_out: true}, %{
        context: %{current_user: user}})

      assert updated_book.user_id == user.id
      assert updated_book.checked_out == true
    end

    test "returns error for unauthenticated user" do
      book = insert(:book)

      {:error, error} =
        BookResolver.update(nil, %{id: book.id, checked_out: true}, nil)

      assert error == "Unauthenticated"
    end
  end
end
