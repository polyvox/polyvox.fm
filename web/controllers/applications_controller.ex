defmodule Polyvox.ApplicationsController do
  use Polyvox.Web, :controller

  def index(conn, _params) do
    conn
    |> render(:index)
  end

  def create(conn, %{"application" => application}) do
    changeset = %Polyvox.Applicant{}
    |> Polyvox.Applicant.changeset(application)

    conn
    |> redirect(to: applications_path(conn, :index))
  end
end
