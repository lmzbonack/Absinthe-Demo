defmodule TcWeb.Resolvers.BookResolver do
  alias Tc.Books

  def list(_parent, _args, _resolution) do
    {:ok, Books.list_books()}
  end

  def show(_parent, args, _resolutions) do
    case Books.get_book!(args[:id]) do
      nil -> {:error, "Not found"}
      book -> {:ok, book}
    end
  end

  @spec create(any, any, any) :: {:error, <<_::120>> | list} | {:ok, any}
  def create(_parent, args, %{
        context: %{current_user: current_user}
      }) do
    args
    |> Books.create_book()
    |> case do
      {:ok, book} ->
        {:ok, book}

      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  # if context does not have a user throw an error
  def create(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  def update(_parent, args, %{
        context: %{current_user: current_user}
      }) do
    book = Books.get_book!(args.id)

    case Books.update_book(book, %{checked_out: args.checked_out, user_id: current_user.id}) do
      {:ok, book} ->
        {:ok, book}

      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  def update(_parent, _args, _resolutions) do
    {:error, "Unauthenticated"}
  end

  defp extract_error_msg(changeset) do
    changeset.errors
    |> Enum.map(fn {field, {error, _details}} ->
      [
        field: field,
        message: String.capitalize(error)
      ]
    end)
  end
end
