defmodule Polyvox.InsiderTradingController do
  use Polyvox.Web, :controller

  def new(conn, _) do
    conn
    |> render(:new)
  end

  def create(conn, %{"session" => %{"name" => insider, "password" => pass}}) do
    case Polyvox.Auth.login_by_name_and_pass(conn, insider, pass, repo: Repo) do
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

  def delete(conn, _) do
    conn
    |> Polyvox.Auth.logout
    |> redirect(to: "/")
  end
end
