defmodule Collector.Schema.Movies do
  alias Collector.Repo
  import Ecto.Query
  alias Collector.Schema.Movie
  alias Collector.Schema.Country
  alias Collector.Schema.Genre
  alias Collector.Schema.Actor

  require Logger

  # Collector.Schema.Movies.create_countries(["amrica", "iran"])
  # filter existed countries by name and insert not existed
  def create_countries(list)do
     existed = Repo.all(from c in Country, where: c.name in ^list, select: c.name)

     not_existed = Enum.filter(list, &(&1 not in existed))
     |> Enum.map(fn country -> %{name: country} end)

     Repo.insert_all(Country, not_existed)
  end

  # Collector.Schema.Movies.get_countries_by_name ["amrica", "iran"]
  # get countries by  list of names
  def get_countries_by_name(countries)do
    query = from c in Country, where: c.name in ^countries
    Repo.all(query)
  end

  # Collector.Schema.Movies.create_genres ["vahshatnak", "komodi"]
  # filter existed genres by name and insert not existed
  def create_genres(list)do
    existed = Repo.all(from g in Genre, where: g.name in ^list, select: g.name)

    not_existed = Enum.filter(list, &(&1 not in existed))
    |> Enum.map(fn genre -> %{name: genre} end)

    Repo.insert_all(Genre, not_existed)
  end
  # Collector.Schema.Movies.get_genres_by_name ["komodi"]
  # get genres by list of name
  def get_genres_by_name(genres)do
    query = from g in Genre, where: g.name in ^genres
    Repo.all(query)
  end

  # Collector.Schema.Movies.create_actors [%{url: "a", name: "a"}, %{url: "b", name: "b"}]
  # filter existed actors by name and insert not existed
  def create_actors(list)do
    urls = Enum.map(list, fn actor -> actor.url end)
    existed = Repo.all(from a in Actor, where: a.url in ^urls, select: a.url)

    not_existed = Enum.filter(list, &(&1.url not in existed))
    # |> Enum.map(fn actor -> %{name: genre} end)

    Repo.insert_all(Actor, not_existed)
  end
  # get genres by list of name
  def get_actors_by_url(actor_urls)do
    query = from a in Actor, where: a.url in ^actor_urls
    Repo.all(query)
  end

  # Collector.Schema.Movies.create_movie %{movie_id: "asdfg",actors_url: ["a"],  genre: ["komodi"], country: ["amrica", "iran"]}
  # Collector.Schema.Movies.create_movie %{movie_id: "asdfg", country: ["amrica", "iran"]}
  # create movies
  def create_movie(movie)do
    Logger.debug("CREATING MOVIE")
    Movie.changeset(%Movie{}, movie)
    |> Movie.changeset_update_countries(get_countries_by_name(movie.country))
    |> Movie.changeset_update_genres(get_genres_by_name(movie.genre))
    |> Movie.changeset_update_actors(get_actors_by_url(movie.actors_url))
    |> Repo.insert()
  end
  # get movie by movie_id

  def get_one_movie_link()do
    Repo.transaction(fn ->
      query1 = from ml in "movies_links", where: ml.collected == false, limit: 1, select: ml.link
      url = Repo.one(query1)
      if url != nil do
        query2 = from ml in "movies_links", where: ml.link == ^url, update: [set: [collected: true]]
        Repo.update_all(query2, [])
      end
      url
     end)
  end

  def update_back_url(url)do
    Repo.transaction(fn ->
      query = from ml in "movies_links", where: ml.link == ^url, update: [set: [collected: false]]
      Repo.update_all(query, [])
      # query = from m in Movie, where: m.link == ^url, select: m.movie_id
      # movie_id = Repo.one(query)
      # query = from c in Comment, where: c.movie_id == ^movie_id
      # Repo.delete_all(query)
    end)

  end

"""

"""

end
