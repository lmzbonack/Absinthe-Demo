defmodule TcWeb.Schema.LibraryTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias TcWeb.Data
  alias TcWeb.Resolvers.LibraryResolver

  @desc "library object"
  object :library do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :address, non_null(:string)

    field :books, non_null(list_of(non_null(:book))), resolve: dataloader(Data)
  end

  object :library_queries do
    @desc "List libraries"
    field :libraries, non_null(list_of(non_null(:library))) do
      resolve(&LibraryResolver.list/3)
    end

    @desc "Get a single library"
    field :library, non_null(:library) do
      arg(:id, non_null(:id))

      resolve(&LibraryResolver.show/3)
    end
  end

  object :library_mutations do
    @desc "Create Libary"
    field :create_library, :library do
      arg(:name, non_null(:string))
      arg(:address, non_null(:string))

      resolve(&LibraryResolver.create/3)
    end
  end
end
