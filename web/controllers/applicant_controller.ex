defmodule Polyvox.ApplicantController do
  use Polyvox.Web, :controller

  alias Polyvox.Applicant

  plug :scrub_params, "applicant" when action in [:create, :update]
  plug :put_layout, "insiders.html"
  plug :authenticate

  def index(conn, _params) do
    applicants = Repo.all(Applicant)
    render(conn, "index.html", applicants: applicants)
  end

  def delete(conn, %{"id" => id}) do
    applicant = Repo.get!(Applicant, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(applicant)

    conn
    |> put_flash(:info, "Applicant deleted successfully.")
    |> redirect(to: applicant_path(conn, :index))
  end

  defp authenticate(conn, _) do
    if conn.assigns.current_insider do
      conn
    else
      conn
      |> redirect(to: insider_trading_path(conn, :new))
    end
  end
end
