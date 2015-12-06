defmodule Polyvox.ApplicationsController do
  use Polyvox.Web, :controller

  def index(conn, _params) do
    conn
    |> render(:index)
  end
end
