defmodule Content.Schema.Entity do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo

  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "entities" do
    field :entity_key, :string
    field :image, :string
    field :vocabulary, :boolean
    belongs_to :translation_map_id, Content.Schema.TranslationMap, foreign_key: :phrase, references: :id,  on_replace: :update
    has_one :other_image, Content.Schema.EntityImage, foreign_key: :entity_key, on_replace: :update
    has_many :videos, Content.Schema.EntityVideo, on_replace: :delete
  end

  @fields ~w(entity_key image vocabulary)a
  def changeset(_entity, params \\ %{})do
    Ecto.build_assoc(get_str(params.phrase), :enities)
    |> cast(params, @fields)
    |> unique_constraint(:entity_key, name: :entity_key_unique_constraint)
    |> cast_assoc(:videos, with: &Content.Schema.EntityVideo.changeset/2)
    |> cast_assoc(:other_image, with: &Content.Schema.EntityImage.changeset/2)
  end
  def to_db(list)do
    alias Content.Schema.Entity
    list
    |> filter_duplicates()
    |> Enum.map(&changeset(%Entity{}, &1))
    |> insert_all()
  end

  defp get_str(phrase)do
    alias Content.Schema.TranslationMap
    Repo.get_by(TranslationMap, str_key: phrase)
  end

  def filter_duplicates(schemas)do
    selected = schemas |> get_schemas()
    schemas
    |> Enum.filter(fn schema -> schema.entity_key not in selected end)
  end

  defp get_schemas(schemas)do
    import Ecto.Query
    alias Content.Schema.Entity
    key_list = Enum.map(schemas, &(&1.entity_key))
    Repo.all(from e in Entity, where: e.entity_key in ^key_list, select: e.entity_key)
  end

  def insert_all(data)do
    Repo.transaction(fn ->
      Enum.each(data, fn changeset ->
        {res, err} = Repo.insert(changeset)
        if(res == :error, do: Repo.rollback(err))
      end)
    end)
  end

end
