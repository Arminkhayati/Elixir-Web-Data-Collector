defmodule Collector.Server.DBController do
  use GenServer
  import Collector.Schema.Comments
  import Collector.Schema.Movies
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_arg, name: __MODULE__)
  end

  def get_one_movie()do
    GenServer.call(__MODULE__, :get_movie)
  end

  def add_data(movie, comments)do
    GenServer.call(__MODULE__, {:add, movie, comments})
  end


  def init(_)do
    { :ok, nil }
  end


  def handle_call(:get_movie, _from, _)do
    {:reply, get_one_movie_link() ,nil}
  end
  def handle_call({:add, movie, comments}, _from , _)do
    result = add(movie, comments)
    {:reply, result ,nil}
  end

  defp add(movie, comments)do
    case add_movie(movie) do
      :ok ->
        case add_comments(comments) do
          :ok -> %{movie: :ok, comments: :ok}
          error ->
            comment = List.first(comments)
            File.write("REJECTED_COMMENTS.TXT", comment.movie_id <> "\n" , [:write, :append])
            %{movie: :ok, comments: error}
        end
      error ->
        File.write("REJECTED_MOVIES.TXT", movie.link <> "\n" , [:write, :append])
        %{movie: error, comments: :canceled}
    end
  end


  ###################


  defp add_comments(comments)do
    create_comments(comments)
    |> case do
      {_, nil} -> :ok
      error -> error
    end
  end

  defp add_movie(movie)do
    insert_movie(movie)
    |> case do
      {:ok, _} -> :ok
      error -> error
    end
  end


  defp insert_movie(movie)do
    insert_actors(movie.actors, movie.actors_url)
    create_genres(movie.genre)
    create_countries(movie.country)
    create_movie(movie)
  end

  defp insert_actors(names, urls)do
    Enum.zip(names, urls)
    |> Enum.map(fn {name, url} -> %{name: name, url: url} end)
    |> create_actors()
  end

  # defp role_back_url(url)do
  #   update_back_url(url)
  # end

end
