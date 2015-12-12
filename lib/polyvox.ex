defmodule Polyvox do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Polyvox.Endpoint, []),
      # Start the Ecto repository
      worker(Polyvox.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Polyvox.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Polyvox.Supervisor]
    start_value = Supervisor.start_link(children, opts)

    repo_env = Application.get_env(:polyvox, Polyvox.Repo)
    if (repo_env |> Keyword.get(:auto_migrate, false)) do
      migrate_database
    end

    start_value
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Polyvox.Endpoint.config_change(changed, removed)
    :ok
  end

  @doc """
  Migrates the database on system startup.
  """
  def migrate_database() do
    Logger.info("Migrating the database")
    Mix.Ecto.ensure_started(Polyvox.Repo)
    repo = Polyvox.Repo
    mig_path = Application.app_dir(:polyvox, "priv/repo/migrations")
    Logger.info("Using migrations path at #{mig_path}")
    :ok = case Ecto.Storage.up(repo) do
            :ok ->
              Logger.info("The database for #{inspect repo} has been created.")
              :ok
            {:error, :already_up} ->
              Logger.info("The database for #{inspect repo} has already been created.")
              :ok
            {:error, term} ->
              Logger.error("The database for #{inspect repo} cannot be created: #{term}.")
              :error
          end
    Ecto.Migrator.run(repo, mig_path, :up, [all: true, log: :info])
  end
end
