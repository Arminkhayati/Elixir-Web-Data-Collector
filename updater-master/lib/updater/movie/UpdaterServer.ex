defmodule Updater.Movie.UpdaterServer do
  use GenServer, restart: :transient
  alias Updater.Movie.MovieHandler
  alias Updater.Movie.Updater

  def start_link(_)do
    GenServer.start_link(__MODULE__, :no_arg)
  end


  def init(_)do
    Process.send_after(self(), :start, 0)
    {:ok, :no_arg}
  end

  def handle_info(:start, _) do
    case MovieHandler.get_movie() do
      {:continue, movie} ->
        Updater.start(movie) |> IO.inspect()
        Process.send_after(self(), :start, 0)
        {:noreply, :no_arg}
       {:done, movie} ->
         Updater.start(movie)
         {:stop, :normal, :no_arg}
       {:done, nil} -> {:stop, :normal, :no_arg}
    end
  end

end
