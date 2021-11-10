defmodule Collector.Schema.Movie do
  use Ecto.Schema
  # use Collector.Schema
  alias Collector.Schema.Genre
  alias Collector.Schema.Country
  alias Collector.Schema.Actor
  # alias Collector.Schema.Movie
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "movies" do
    field :movie_id, :string
    field :name, :string
    field :year, :integer
    field :age, :string
    field :imdb_score, :float
    field :imdb_voters, :integer
    field :imdb_link, :string
    field :diba_score, :float
    field :diba_voters, :integer
    field :quality, :string
    field :critics_score, :integer
    field :total_sell, :string
    field :duration, :string
    field :description, :string
    field :director, :string
    field :director_url, :string
    field :dubbed, :string
    field :link, :string
    many_to_many(:genres, Genre, join_through: "movies_genres", on_replace: :delete)
    many_to_many(:countries, Country, join_through: "movies_countries", on_replace: :delete)
    many_to_many(:actors, Actor, join_through: "movies_actors", on_replace: :delete)
  end

  @fields ~w(link dubbed director_url director description duration total_sell
  critics_score movie_id name year age imdb_score imdb_voters
  imdb_link diba_score diba_voters quality)a
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, @fields)
    |> unique_constraint(:movie_id)
  end

  def changeset_update_genres(movie, genres) do
    movie
    # |> cast(%{}, @fields)
    # associate projects to the user
    |> put_assoc(:genres, genres)
  end

  def changeset_update_countries(movie, countries) do
    movie
    # |> cast(%{}, @fields)
    # associate projects to the user
    |> put_assoc(:countries, countries)
  end

  def changeset_update_actors(movie, actors) do
    movie
    # |> cast(%{}, @fields)
    # associate projects to the user
    |> put_assoc(:actors, actors)
  end

end
