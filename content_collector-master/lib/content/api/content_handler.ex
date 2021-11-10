defmodule Content.Api.ContentHandler do

  alias Content.Schema.Lesson
  alias Content.Repo

  def get_lesson_by_id(id)do
    result = Repo.get_by(Lesson, lesson_id: id)
    |> Repo.preload([:lesson_content,
              {:units, :content},
              {:units, :root_structs},
              {:units, [{:root_structs, :leafs}]}
              ])
    {:ok, result}
  end

  def get_lessons_list()do
    Repo.all(Lesson)
    |> Repo.preload([:lesson_content,
                      {:units, :content},
                      {:units, :root_structs}
                      ])
    |> case  do
      [%Lesson{} | _] = lessons ->
        result = lessons |> Enum.map(&to_map/1)
        {:ok, result}
      _ -> {:error, :lesson_table}
    end
  end

  # defp to_map(lesson = %Content.Schema.Lesson{lesson_content: lesson_content, units: units})do
  #   lesson = lesson_to_map(lesson_content)
  # end
  #
  # defp lesson_to_map()do
  #   lesson = _to_map(lesson)
  #   lesson = %{lesson | lesson_content: _to_map(lesson_content)}
  # end
  #
  # defp unit_to_map(units)do
  #
  # end
  #
  # @schema_meta_fields [:__meta__, :id]
  #
  # defp _to_map(struct) do
  #   association_fields = struct.__struct__.__schema__(:associations)
  #   IO.inspect(association_fields)
  #   waste_fields = @schema_meta_fields
  #   struct |> Map.from_struct |> Map.drop(waste_fields)
  # end
  #
  #
  #
  #
  defp lesson_to_map(lesson)do
    %{
      number: lesson.number,
      level: lesson.level,
      lesson_id: lesson.lesson_id,
      class: lesson.class,
      type: lesson.type,
      lesson_content: lesson_content_to_map(lesson.lesson_content)
    }
  end

  defp lesson_content_to_map(content)do
    %{
      title: content.title,
      image: content.image,
      image_svg: content.image_svg,
      thumbnail_256: content.thumbnail_256,
      description: content.description,
      color1: content.color1,
      color2: content.color2,
      bucket: content.bucket,
    }
  end


end
