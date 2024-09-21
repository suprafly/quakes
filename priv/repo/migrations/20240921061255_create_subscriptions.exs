defmodule Quakes.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :endpoint, :string
      add :start, :utc_datetime, default: fragment("now()")
      add :filters, :map
    end
  end
end
