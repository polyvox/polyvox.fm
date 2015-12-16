defmodule PolyvoxMarketing.InsiderTradingController do
  use PolyvoxMarketing.Web, :controller

  plug :authenticate when action in [:edit, :update]
  plug :scrub_params, "update" when action in [:update]

  def new(conn, _) do
    conn
    |> render(:new)
  end

  def create(conn, %{"session" => %{"name" => insider, "password" => pass}}) do
    case PolyvoxMarketing.Auth.login_by_name_and_pass(conn, insider, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> redirect(to: applicant_path(conn, :index))
      {:error, :not_found, conn} ->
        conn
        |> render(:new)
      {:error, :unauthorized, conn} ->
        conn
        |> redirect(to: "/")
    end
  end

  def edit(conn, _) do
    conn
    |> put_layout("insiders.html")
    |> render(:edit, changeset: nil)
  end

  def update(conn, %{"update" => params}) do
    outcome = conn.assigns.current_insider
    |> PolyvoxMarketing.Insider.password_changeset(params)
    |> Repo.update

    case outcome do
      {:ok, _} ->
        conn
        |> redirect(to: applicant_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_layout("insiders.html")
        |> render(:edit, changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> PolyvoxMarketing.Auth.logout
    |> redirect(to: "/")
  end

  defp authenticate(conn, _) do
    if conn.assigns.current_insider do
      conn
    else
      conn
      |> redirect(to: insider_trading_path(conn, :new))
      |> halt
    end
  end
end
