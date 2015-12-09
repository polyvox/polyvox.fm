defmodule Polyvox.ApplicationsController do
  use Polyvox.Web, :controller

  plug :scrub_params, "application" when action in [:create, :update]

  def index(conn, _params) do
    conn
    |> render(:index, changeset: nil)
  end

  def show(conn, %{"id" => id}) do
    model = Polyvox.Applicant
    |> Ecto.Query.where([a], a.said == ^id)
    |> Repo.one
    |> Polyvox.Applicant.changeset(:empty)

    conn
    |> render(:show, applicant: model)
  end

  def create(conn, %{"application" => application}) do
    outcome = %Polyvox.Applicant{}
    |> Polyvox.Applicant.changeset(application)
    |> Polyvox.Repo.insert

    case outcome do
      {:ok, model} ->
        conn
        |> redirect(to: applications_path(conn, :show, model.said))
      {:error, changeset} ->
        outcome = Polyvox.Applicant
        |> Ecto.Query.where([a], a.email == ^application["email"])
        |> Repo.one

        case outcome do
          %{name: nil} ->
            conn
            |> redirect(to: applications_path(conn, :show, outcome.said))
          _ ->
            conn
            |> render(:index, changeset: changeset)
        end
    end
  end

  def update(conn, %{"id" => id, "application" => application}) do
    outcome = Polyvox.Applicant
    |> Ecto.Query.where([a], a.said == ^id)
    |> Repo.one
    |> Polyvox.Applicant.changeset(application)
    |> Polyvox.Repo.update

    case outcome do
      {:ok, model} ->
        conn
        |> redirect(to: applications_path(conn, :show, model.said))
      {:error, changeset} ->
        conn
        |> render(:show, applicant: changeset)
    end
  end
end
