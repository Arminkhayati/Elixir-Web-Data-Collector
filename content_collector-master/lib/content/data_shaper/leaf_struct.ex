defmodule Content.DataShaper.LeafStruct do
  alias Content.Schema.LeafStruct
  def do_leaf_struct(_json = %{"structure" => data})do
    data
    |> Enum.map(&travers_leafs/1)
    |> List.flatten()
    |> LeafStruct.to_db()
    #json
  end

  def travers_leafs(%{"structure" => leafs, "id" => id})do
    leafs
    |> Enum.map(&map_to_schema(&1, id))
  end

  def map_to_schema(a_leaf, root_id)do
    content = a_leaf["content"]
    |> Content.DataShaper.LeafContentParser.parse()
    |> Map.new()
    # |> Jason.encode!()
    # {:ok, file} = File.open("/home/armin/dataaaaa/#{root_id}_#{a_leaf["id"]}.json", [:write, :utf8])
    # IO.write(file, content)
    # File.close(file)
    %{
      struct_id: a_leaf["id"],
      class: a_leaf["class"],
      type: a_leaf["type"],
      icon: a_leaf["icon"],
      content: content,
      root_id: root_id
    }
  end
end
