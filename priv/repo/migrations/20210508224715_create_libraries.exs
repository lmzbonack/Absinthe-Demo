defmodule Tc.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :text
      add :address, :text

      timestamps()
    end

  end
end
