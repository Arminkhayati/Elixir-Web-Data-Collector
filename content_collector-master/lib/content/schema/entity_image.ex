defmodule Content.Schema.EntityImage do
  use Ecto.Schema
  import Ecto.Changeset
  # alias Content.Repo
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "entity_images" do
    field :small, :string
    field :medium, :string
    field :large, :string
    field :xlarge, :string
    belongs_to :entity, Content.Schema.Entity, foreign_key: :entity_key, references: :id, on_replace: :update
  end

  @fields ~w(small medium large xlarge)a
  def changeset(image, params \\ %{})do
    image
    |> cast(params, @fields)
  end

end
