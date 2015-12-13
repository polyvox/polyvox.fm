defmodule Polyvox.Repo.Migrations.CreateInsider do
  use Ecto.Migration

  def change do
    create table(:insiders) do
      add :name, :string
      add :password_hash, :string
      add :password, :string, virtual: true

      timestamps
    end
  end
end
