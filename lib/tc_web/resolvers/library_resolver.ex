defmodule TcWeb.Resolvers.LibraryResolver do
  alias Tc.Libraries

  def list(_parent, _args, _resolution) do
    {:ok, Libraries.list_libraries}
  end

  def show(_parent, args, _resolutions) do
    case Libraries.get_library!(args[:id]) do
      nil -> {:error, "Not found"}
      library -> {:ok, library}
    end
  end

  def create(_parent, args, %{
        context: %{current_user: current_user}
      }) do
    args
    |> Libraries.create_library()
    |> case do
      {:ok, library} ->
        {:ok, library}

      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  # if context does not have a user throw an error
  def create(_parent, _args, _resolutions) do
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
