defmodule Content.Schema.Lesson do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  alias Content.Schema.{Unit, LessonContent}

  @derive {Jason.Encoder, only: [:level, :lesson_id, :class, :type, :units]}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "lessons" do
    field :lesson_id, :string
    field :type, :string
    field :class, :string
    field :level, :string
    field :number, :integer
    has_many :units, Unit, on_replace: :delete
    has_one :lesson_content, LessonContent, on_replace: :update
  end

  @fields ~w(level number lesson_id type class)a
  def changeset(lesson, params \\ %{})do
    lesson
    |> cast(params, @fields)
    |> unique_constraint(:lesson_id, name: :lesson_id_unique_constraint)
  end

  def to_db(lesson)do
    changeset(%__MODULE__{}, lesson)
    |> Repo.insert()
  end
end
