defmodule Tc.Libraries.Library do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tc.Books.Book

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "libraries" do
    field :address, :string
    field :name, :string

    has_many :books, Book

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
  end
end
