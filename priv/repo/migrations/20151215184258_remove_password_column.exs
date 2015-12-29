defmodule PolyvoxMarketing.Repo.Migrations.RemovePasswordColumn do
  use Ecto.Migration

  def change do
    alter table(:insiders) do
      remove :password
    end
  end
end
