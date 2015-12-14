defmodule PolyvoxMarketing.PageController do
  use PolyvoxMarketing.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
