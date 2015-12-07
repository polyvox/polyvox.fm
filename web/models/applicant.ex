defmodule Polyvox.Applicant do
  use Polyvox.Web, :model

  schema "applicants" do
    field :email, :string, null: false
    field :name, :string
    field :priority, :string
    field :podcast_url, :string
    field :podcast_name, :string
    field :said, :integer, null: false

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w(said name priority podcast_url podcast_name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> set_said_if_needed
    |> unique_constraint(:email)
  end

  defp set_said_if_needed(changeset) do
    case fetch_field(changeset, :said) do
      :error ->
        changeset
        |> put_change(:said, generate_said)
      {:changes, nil} ->
        changeset
        |> put_change(:said, generate_said)
      {:model, nil} ->
        changeset
        |> put_change(:said, generate_said)
      _ ->
        changeset
    end
  end

  defp generate_said() do
    :math.pow(2, 31) - 1
    |> round
    |> :rand.uniform
  end
end
