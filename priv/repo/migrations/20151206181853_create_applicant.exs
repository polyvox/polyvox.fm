defmodule Polyvox.Repo.Migrations.CreateApplicant do
  use Ecto.Migration

  def change do
    create table(:applicants) do
      add :email, :string
      add :name, :string
      add :priority, :string
      add :podcast_url, :string
      add :podcast_name, :string

      timestamps
    end

    create unique_index(:applicants, [:email])
  end
end
