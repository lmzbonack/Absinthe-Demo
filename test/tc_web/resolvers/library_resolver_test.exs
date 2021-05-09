defmodule TcWeb.LibraryResolverTest do
  use TcWeb.ConnCase, async: true

  alias TcWeb.Resolvers.LibraryResolver

  describe "list" do
    test "returns libaries" do
      insert(:library)
      insert(:library)

      {:ok, results} = LibraryResolver.list(nil, nil, nil)
      assert length(results) == 2
    end
  end

  describe "show" do
    test "returns specific library" do
      library = insert(:library)
      {:ok, found} = LibraryResolver.show(nil, %{id: library.id}, nil)
      assert found.id == library.id
    end

    test "returns not found when library does not exist" do
      {:error, error} = LibraryResolver.show(nil, %{id: "132312"}, nil)
      assert error == "Not found"
    end
  end

  describe "create" do
    test "creates valid library" do
      user = insert(:user)

      {:ok, library} =
        LibraryResolver.create(nil, %{name: "Lib Name", address: "Lib address"}, %{
          context: %{current_user: user}
        })

      assert library.name == "Lib Name"
      assert library.address == "Lib address"
    end

    test "returns error for missing params" do
      user = insert(:user)

      {:error, error} =
        LibraryResolver.create(nil, %{}, %{
          context: %{current_user: user}
        })

      assert error == [
               [field: :name, message: "Can't be blank"],
               [field: :address, message: "Can't be blank"]
             ]
    end
  end
end
