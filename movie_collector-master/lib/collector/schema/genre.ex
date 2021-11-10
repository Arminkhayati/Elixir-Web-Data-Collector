defmodule Collector.Schema.Genre do
  use Ecto.Schema
  # use Collector.Schema
  alias Collector.Schema.Movie
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "genres" do
    field :name, :string
    many_to_many(:movies, Movie, join_through: "movies_genres", on_replace: :delete)
  end

  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> unique_constraint(:name)
  end

end
