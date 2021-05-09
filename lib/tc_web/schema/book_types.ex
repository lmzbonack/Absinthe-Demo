defmodule TcWeb.Schema.BookTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias TcWeb.Data
  alias TcWeb.Resolvers.BookResolver

  @desc "book object"
  object :book do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :library_id, non_null(:id)
    field :checked_out, non_null(:boolean)

    field :user, :user, resolve: dataloader(Data)
    field :library, non_null(:library), resolve: dataloader(Data)
  end

  object :book_queries do
    @desc "List books"
    field :books, non_null(list_of(non_null(:book))) do
      resolve &BookResolver.list/3
    end

    @desc "Get a single book"
    field :book, non_null(:book) do
      arg :id, non_null(:id)

      resolve &BookResolver.show/3
    end
  end

  object :book_mutations do
    @desc "Create book"
    field :create_book, :book do
      arg :name, non_null(:string)
      arg :library_id, non_null(:string)
      arg :checked_out, :string

      resolve &BookResolver.create/3
    end

    @desc "Check out or return a book"
    field :edit_book, :book do
      arg :id, non_null(:string)
      arg :checked_out, non_null(:boolean)

      resolve &BookResolver.update/3
    end
  end
end
