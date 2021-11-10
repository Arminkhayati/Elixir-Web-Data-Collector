defmodule Updater.Movie.MovieHandler do
  use GenServer, restart: :transient
  alias Updater.Movie.Moviedb

  def get_movie()do
    GenServer.call(:movie_handler, :get_movie)
  end


  def start_link(_)do
    GenServer.start_link(__MODULE__, :no_arg)
  end

  def init(_)do
    Process.register(self(), :movie_handler)
    Process.send_after(self(), :fetch_movies, 0)
    {:ok, :no_arg}
  end

  def handle_info(:fetch_movies, _) do
    {:noreply, Moviedb.get_all()}
  end


  def handle_call(:get_movie, _from, [])do
    {:reply, {:done, nil}, []}
  end
  def handle_call(:get_movie, _from, [movie | []])do
    {:reply, {:done, movie}, []}
  end
  def handle_call(:get_movie, _from, [movie | tail])do
    {:reply, {:continue, movie}, tail}
  end

end
