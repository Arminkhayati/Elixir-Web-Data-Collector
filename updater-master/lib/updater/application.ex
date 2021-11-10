defmodule Updater.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Updater.Movie.Repo, []},
      {Updater.Movie.MovieHandler, nil},
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_1),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_2),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_3),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_4),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_5),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_6),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_7),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_8),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_9),
      Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_10),
      # Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_11),
      # Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_12),
      # Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_13),
      # Supervisor.child_spec({Updater.Movie.UpdaterServer, nil}, id: :my_worker_14),
      # Supervisor.child_spec({Updater.Movie.MovieHandler, nil}, id: :my_worker_2)
      # {Updater.Movie.MovieHandler, id: :m1},
      # {Updater.Movie.MovieHandler, id: :m2},
      # Starts a worker by calling: Updater.Worker.start_link(arg)
      # {Updater.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Updater.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
