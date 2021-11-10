defmodule Content.DataShaper.RootStruct do
    alias Content.Schema.RootStruct

    def do_root_struct(json = %{"structure" => data})do
      data
      |> Enum.map(&map_to_schema/1)
      |> Enum.map(&set_unit(&1,json["id"]))
      |> RootStruct.to_db()
      json
    end

    def set_unit(map, unit)do
      %{map | unit: unit}
    end

    def map_to_schema(data)do
      %{
        struct_id: data["id"],
        class: data["class"],
        type: data["type"],
        icon: data["icon"],
        unit: ""
      }
    end
end
