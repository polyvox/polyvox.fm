defmodule PolyvoxMarketing.ApplicationsController do
  use PolyvoxMarketing.Web, :controller

  plug :scrub_params, "application" when action in [:create, :update]

  def index(conn, _params) do
    conn
    |> render(:index, changeset: nil)
  end

  def show(conn, %{"id" => id}) do
    model = PolyvoxMarketing.Applicant
    |> Ecto.Query.where([a], a.said == ^id)
    |> Repo.one

    case model do
      nil ->
        conn
        |> redirect(to: "/")
      _ ->
        conn
        |> render(:show, applicant: PolyvoxMarketing.Applicant.changeset(model, :empty))
    end
  end

  def create(conn, %{"application" => application}) do
    outcome = %PolyvoxMarketing.Applicant{}
    |> PolyvoxMarketing.Applicant.changeset(application)
    |> PolyvoxMarketing.Repo.insert

    case outcome do
      {:ok, model} ->
        conn
        |> redirect(to: applications_path(conn, :show, model.said))
      {:error, changeset} ->
        outcome = PolyvoxMarketing.Applicant
        |> Ecto.Query.where([a], a.email == ^application["email"])
        |> Repo.one

        case outcome do
          %{name: nil, podcast_url: nil, podcast_name: nil} ->
            conn
            |> redirect(to: applications_path(conn, :show, outcome.said))
          _ ->
            conn
            |> render(:index, changeset: changeset)
        end
    end
  end

  def update(conn, %{"id" => id, "application" => application}) do
    outcome = PolyvoxMarketing.Applicant
    |> Ecto.Query.where([a], a.said == ^id)
    |> Repo.one
    |> PolyvoxMarketing.Applicant.changeset(application)
    |> PolyvoxMarketing.Repo.update

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
