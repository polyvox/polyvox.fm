defmodule Polyvox.ApplicationController do
  use Polyvox.Web, :controller

  def update(conn, _params) do
    conn
    |> redirect(to: "/thanks_even_more.html")
  end
end
