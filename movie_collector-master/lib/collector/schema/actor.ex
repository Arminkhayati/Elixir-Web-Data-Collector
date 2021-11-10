defmodule Collector.Schema.Actor do
  use Ecto.Schema
  # use Collector.Schema
  alias Collector.Schema.Movie
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "actors" do
    field :name, :string
    field :url, :string
    many_to_many(:movies, Movie, join_through: "movies_actors", on_replace: :delete)
  end

  def changeset(actor, attrs) do
    actor
    |> cast(attrs, [:name, :url])
    |> unique_constraint(:url)
  end
end
