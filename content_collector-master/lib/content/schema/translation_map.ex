defmodule Content.Schema.TranslationMap do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "translations" do
    field :str_key, :string
    field :value, :string
    field :audio, :string
    field :alternative_value, :string
    field :has_audio, :boolean
    has_many :enities, Content.Schema.Entity, foreign_key: :phrase, on_replace: :delete
  end

  @fields ~w(str_key value audio alternative_value has_audio)a
  # @required_values ~w(str_key value)a
  def changeset(schema, params \\ %{})do
    schema
    |> cast(params, @fields)
    |> unique_constraint(:str_key, name: :trans_key_unique_constraint)
    # |> validate_required(@required_values)
  end

  def to_db(schemas)do
    alias Content.Schema.TranslationMap
    schemas
    |> filter_duplicates()
    |> Enum.map(&changeset(%TranslationMap{},&1))
    |> insert_all()
  end

  def filter_duplicates(schemas)do
    selected = schemas |> get_schemas()
    schemas
    |> Enum.filter(fn schema -> schema.str_key not in selected end)
  end

  defp get_schemas(schemas)do
    import Ecto.Query
    alias Content.Schema.TranslationMap
    key_list = Enum.map(schemas, &(&1.str_key))
    Repo.all(from t in TranslationMap, where: t.str_key in ^key_list, select: t.str_key)
  end

  def insert_all(data)do
    Repo.transaction(fn ->
      Enum.each(data, fn changeset ->
        {res, _} = Repo.insert(changeset)
        if(res == :error, do: Repo.rollback(:duplicate_translation_map))
      end)
    end)
  end


end
