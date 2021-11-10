defmodule Content.Schema.LeafStruct do
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Repo
  @fields ~w(struct_id class type content)a

  @derive {Jason.Encoder, only: @fields}
  @foreign_key_type :binary_id
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "leaf_structs" do
    field :struct_id, :string
    field :class, :string
    field :type, :string
    field :content, :map
    belongs_to :root_struct_id, Content.Schema.RootStruct, foreign_key: :root_id, references: :id,  on_replace: :update
  end

  def changeset(_leaf, params \\ %{})do
    Ecto.build_assoc(get_root(params.root_id), :leafs)
    |> cast(params, @fields)
  end

  def to_db(leafs)do
    leafs
    |> filter_duplicates()
    |> Enum.map(&changeset(%__MODULE__{}, &1))
    |> insert_all()
  end

  def get_root(struct_id)do
    Repo.get_by(Content.Schema.RootStruct, struct_id: struct_id)
  end

  def filter_duplicates(schemas)do
    selected = schemas |> get_schemas()
    schemas
    |> Enum.filter(fn schema -> schema.struct_id not in selected end)
  end

  defp get_schemas(schemas)do
    import Ecto.Query
    Enum.map(schemas, fn %{root_id: root_id, struct_id: struct_id} ->
      root_id = get_root(root_id).id
      Repo.one(from ls in __MODULE__, where: ls.root_id == ^root_id and ls.struct_id == ^struct_id, select: ls.struct_id)
    end)

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
