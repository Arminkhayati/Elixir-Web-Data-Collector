defmodule Content.Schema.EntityVideo do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "entity_videos" do
    field :type, :string
    field :size, :string
    field :link, :string
    belongs_to :entity, Content.Schema.Entity, foreign_key: :entity_id, on_replace: :update
  end

  @fields ~w(type size link)a
  def changeset(video, params \\ %{})do
    IO.inspect(video)
    video
    |> cast(params, @fields)
  end
end
