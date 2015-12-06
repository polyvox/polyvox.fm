defmodule Polyvox.Applicant do
  use Polyvox.Web, :model

  schema "applicants" do
    field :email, :string
    field :name, :string
    field :priority, :string
    field :podcast_url, :string
    field :podcast_name, :string

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w(name priority podcast_url podcast_name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
  end
end
