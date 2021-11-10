defmodule Content.DataShaper.Lesson do
  alias Content.Schema.Lesson

  def do_lesson(json)do
    json
    |> map_to_schema()
    |> Lesson.to_db()
    json
  end

  def map_to_schema(data)do
    %{
      lesson_id: data["id"],
      class: data["class"],
      type: data["type"],
      level: data["level"],
      number: data["number"],
    }
  end
end
