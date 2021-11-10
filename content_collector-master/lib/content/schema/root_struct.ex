defmodule Content.Schema.RootStruct do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo

  @derive {Jason.Encoder, only: [:struct_id, :class, :type, :icon, :leafs]}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "root_structs" do
    field :struct_id, :string
    field :class, :string
    field :type, :string
    field :icon, :string
    belongs_to :unit, Content.Schema.Unit, on_replace: :update
    has_many :leafs, Content.Schema.LeafStruct, foreign_key: :root_id, on_replace: :delete
  end

  @fields ~w(struct_id class type icon)a
  def changeset(_root_struct, params \\ %{})do
    Ecto.build_assoc(get_unit(params.unit), :root_structs)
    |> cast(params, @fields)
    |> cast_assoc(:leafs, with: &Content.Schema.LeafStruct.changeset/2)
    |> unique_constraint(:struct_id, name: :struct_id_unique_constraint)
  end

  def to_db(structs)do
    structs
    |> filter_duplicates()
    |> Enum.map(&changeset(%__MODULE__{}, &1))
    |> insert_all()
  end

  def get_unit(unit_id)do
    Repo.get_by(Content.Schema.Unit, unit_id: unit_id)
  end

  def filter_duplicates(schemas)do
    selected = schemas |> get_schemas()
    schemas
    |> Enum.filter(fn schema -> schema.struct_id not in selected end)
  end

  defp get_schemas(schemas)do
    import Ecto.Query
    key_list = Enum.map(schemas, &(&1.struct_id))
    Repo.all(from rs in __MODULE__, where: rs.struct_id in ^key_list, select: rs.struct_id)
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
