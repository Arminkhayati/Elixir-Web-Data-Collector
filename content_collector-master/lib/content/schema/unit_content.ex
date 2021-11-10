defmodule Content.Schema.UnitContent do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  @fields ~w(title image1024 image2048)a

  @derive {Jason.Encoder, only: @fields}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "unit_contents" do
    field :title, :string
    field :image1024, :string
    field :image2048, :string
    belongs_to :unit, Content.Schema.Unit, on_replace: :update
  end


  def changeset(_unit_content, params \\ %{})do
    Ecto.build_assoc(get_unit(params.unit), :content)
    |> cast(params, @fields)
    |> unique_constraint(:unit, name: :unit_contents_unit_id_index)
  end

  def to_db(content)do
    content = get_title(content)
    changeset(%__MODULE__{}, content)
    |> Repo.insert()
  end
  def get_title(content)do
    import Ecto.Query
    title = Repo.one(from t in Content.Schema.TranslationMap, where: t.str_key == ^content.title, select: t.value)
    %{content | title: title}
  end
  def get_unit(unit_id)do
    Repo.get_by(Content.Schema.Unit, unit_id: unit_id)
  end


end
