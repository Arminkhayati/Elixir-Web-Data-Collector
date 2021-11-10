defmodule Content.DataShaper.Unit do
  alias Content.Schema.Unit

  def do_unit(json, lesson_id)do
    json
    |> map_to_schema(lesson_id)
    |> Unit.to_db()
    json
  end

  def map_to_schema(data, lesson_id)do
    %{
      unit_id: data["id"],
      class: data["class"],
      type: data["type"],
      time_estimate: data["time_estimate"],
      lesson_id: lesson_id
    }
  end
end
