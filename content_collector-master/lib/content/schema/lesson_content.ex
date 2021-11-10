defmodule Content.Schema.LessonContent do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Content.Repo
  alias Content.Schema.{Lesson, LessonContent, TranslationMap}

  @fields ~w(title image image_svg thumbnail_256 description color1 color2 bucket)a

  @derive {Jason.Encoder, only: @fields}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "lesson_contents" do
    belongs_to :lesson, Lesson, on_replace: :update
    field :title, :string
    field :image, :string
    field :image_svg, :string
    field :thumbnail_256, :string
    field :description, :string
    field :color1, :string
    field :color2, :string
    field :bucket, :integer
  end

  def changeset(content, params \\ %{})do
    content
    |> cast(params, @fields)
    |> unique_constraint(:unit, name: :lesson_contents_lesson_id_index)
  end

  def to_db(content) do
    id = get_lesson(content.lesson_id)
    changeset(%LessonContent{}, content)
    |> put_change(:lesson_id, id)
    |> Repo.insert()
  end


  def get_lesson(lesson_id)do
    query = from l in Lesson, where: l.lesson_id == ^lesson_id, select: l.id
    Repo.one(query)
  end

  def get_translation(str)do
    query = from t in TranslationMap, where: t.str_key == ^str, select: t.value
    Repo.one(query)
  end
end
