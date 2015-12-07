defmodule Polyvox.Repo.Migrations.CreateApplicant do
  use Ecto.Migration

  def change do
    create table(:applicants) do
      add :email, :string
      add :name, :string
      add :priority, :string
      add :podcast_url, :string
      add :podcast_name, :string
      add :said, :integer

      timestamps
    end

    create unique_index(:applicants, [:email])
    create unique_index(:applicants, [:said])
  end
end
