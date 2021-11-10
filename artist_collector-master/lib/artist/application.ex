defmodule Artist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Collector.Repo, []},
      # {Collector.Server.DBController, nil},
      # {DynamicSupervisor, strategy: :one_for_one, name: Collector.DynamicSupervisor},
      {Collector.Server.StateSaver, %{urls: [], page: "http://mydiba.site/type/director/", collectors: 3}},
      # {Collector.Server.URLCollector, nil},
      # Starts a worker by calling: Artist.Worker.start_link(arg)
      # {Artist.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Artist.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
