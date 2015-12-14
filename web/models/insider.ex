defmodule Polyvox.Insider do
  use Polyvox.Web, :model

  schema "insiders" do
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps
  end

  def password_changeset(model, params \\ :empty) do
    changeset = model
    |> cast(params, ~w(password password_confirmation), [])
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password, message: "passwords do not match")
    |> put_hashed_password

    IO.inspect(changeset)

    changeset
  end

  defp put_hashed_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    changeset
    |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
  end

  defp put_hashed_password(changeset) do
    changeset
  end
end
