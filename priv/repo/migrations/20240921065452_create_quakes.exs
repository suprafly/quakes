defmodule Quakes.Repo.Migrations.CreateQuakes do
  use Ecto.Migration

  def change do
    create table(:quakes, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :type, :string
      add :properties, :map
      add :geometry, :map
    end
  end
end
