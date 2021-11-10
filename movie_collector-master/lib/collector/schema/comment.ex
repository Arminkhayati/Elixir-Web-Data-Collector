defmodule Collector.Schema.Comment do
  use Ecto.Schema
  # use Collector.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :comment_id, :string
    field :comment, :string
    field :parent, :string
    field :movie_id, :string
    field :author, :string
    field :like, :string
    field :dislike, :string
  end

  @fields ~w(comment_id comment parent movie_id author like dislike)a
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, @fields)
    |> unique_constraint(:comment_id)
  end

end
