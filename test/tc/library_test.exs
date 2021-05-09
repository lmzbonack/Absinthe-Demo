defmodule Tc.LibrariesTest do
  use TcWeb.ConnCase, async: true

  alias Tc.Libraries
  alias Tc.Libraries.Library

  @valid_attrs %{name: "some name", address: "some address"}

  describe "create" do
    test "creates library" do
      {:ok, library} =
        @valid_attrs
        |> Libraries.create_library()

      assert library.name == "some name"
    end
  end

  describe "finds library" do
    test "finds list of libraries" do
      insert(:library)
      insert(:library)

      libraries = Libraries.list_libraries()

      assert Enum.count(libraries) == 2
    end

    test "finds single library" do
      library_one = insert(:library)

      library = Libraries.get_library!(library_one.id)

      assert library.id == library_one.id
    end
  end

  describe "changest" do
    test "validates with correct changeset" do
      changeset = Tc.Libraries.change_library(%Library{}, @valid_attrs)
      assert changeset.valid?
    end

    test "does not validate without an adderes" do
      changeset = Tc.Libraries.change_library(%Library{}, %{name: "some name"})
      refute changeset.valid?
    end
  end
end
