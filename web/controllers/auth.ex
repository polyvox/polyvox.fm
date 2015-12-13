defmodule Polyvox.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2]

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    insider_id = get_session(conn, :insider_id)
    insider = insider_id && repo.get(Polyvox.Insider, insider_id)
    assign(conn, :current_insider, insider)
  end

  def login(conn, insider) do
    conn
    |> assign(:current_insider, insider)
    |> put_session(:insider_id, insider.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    conn
    |> configure_session(drop: true)
  end

  def login_by_name_and_pass(conn, name, given_pass, opts) do
    repo = Keyword.fetch!(opts, :repo)
    insider = repo.get_by(Polyvox.Insider, name: name)

    cond do
      insider && checkpw(given_pass, insider.password_hash) ->
        {:ok, login(conn, insider)}
      insider ->
        {:error, :unauthorized, conn}
      true ->
        {:error, :not_found, conn}
    end
  end
end
