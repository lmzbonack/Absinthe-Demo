defmodule TcWeb.Schema do
  use Absinthe.Schema

  alias TcWeb.Data

  import_types(Absinthe.Type.Custom)
  import_types(TcWeb.Schema.UserTypes)
  import_types(TcWeb.Schema.LibraryTypes)
  import_types(TcWeb.Schema.BookTypes)

  query do
    import_fields(:user_queries)
    import_fields(:library_queries)
    import_fields(:book_queries)
  end

  mutation do
    import_fields(:user_mutations)
    import_fields(:library_mutations)
    import_fields(:book_mutations)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Data, Data.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
