defmodule Content.Schema.Unit do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias Content.Repo
  alias Content.Schema.Lesson

  @derive {Jason.Encoder, only: [:unit_id, :class, :type, :time_estimate, :content, :root_structs]}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "units" do
    belongs_to :lesson, Lesson, on_replace: :update

    field :unit_id, :string
    field :class, :string
    field :type, :string
    field :time_estimate, :integer
    has_one :content, Content.Schema.UnitContent, on_replace: :update
    has_many :root_structs, Content.Schema.RootStruct, on_replace: :delete
  end

  @fields ~w(unit_id class type time_estimate)a

  def changeset(unit, params \\ %{})do
    unit
    |> cast(params, @fields)
    |> cast_assoc(:content, with: &Content.Schema.UnitContent.changeset/2)
    |> cast_assoc(:content, with: &Content.Schema.RootStruct.changeset/2)
    |> unique_constraint(:unit_id, name: :units_id_unique_constraint)
  end

  def to_db(unit)do
    id = get_lesson(unit.lesson_id)
    changeset(%__MODULE__{}, unit)
    |> put_change(:lesson_id, id)
    |> Repo.insert()
  end

  def get_lesson(lesson_id)do
    query = from l in Lesson, where: l.lesson_id == ^lesson_id, select: l.id
    Repo.one(query)
  end


end
