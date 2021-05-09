defmodule Tc.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text
      add :checked_out, :boolean, default: false, null: false
      add :user_id, references(:users, type: :uuid, on_delete: :nilify_all)
      add :library_id, references(:libraries, type: :uuid, on_delete: :nilify_all)

      timestamps()
    end

  end
end
