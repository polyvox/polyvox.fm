defmodule Polyvox.Insider do
  use Polyvox.Web, :model

  schema "insiders" do
    field :name, :string
    field :password_hash, :string

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
