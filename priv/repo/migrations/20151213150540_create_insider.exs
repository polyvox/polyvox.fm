defmodule Polyvox.Repo.Migrations.CreateInsider do
  use Ecto.Migration

  def change do
    create table(:insiders) do
      add :name, :string
      add :password_hash, :string
      add :password, :string, virtual: true

      timestamps
    end

    def password_changeset(model, params \\ :empty) do
      model
      |> cast(params, ~w(password), [])
      |> validate_length(:password, min: 6, max: 100)
      |> put_hashed_password
    end

    defp put_hashed_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
      changeset
      |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
    end

    defp put_hashed_password(changeset) do
      changeset
    end
  end
end
