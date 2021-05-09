defmodule Tc.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tc.Accounts.User
  alias Tc.Libraries.Library

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "books" do
    field :checked_out, :boolean, default: false
    field :name, :string

    belongs_to :user, User
    belongs_to :library, Library

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :checked_out, :user_id, :library_id])
    |> validate_required([:name, :checked_out, :library_id])
    |> foreign_key_constraint(:library_id)
  end
end
