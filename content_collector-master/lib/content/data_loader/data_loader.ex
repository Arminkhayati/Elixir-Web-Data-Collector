defmodule Content.DataLoader do

  def start(_link) do
    # File.read!("/home/armin/Data/Development/Elixir/internet_prjoect/busuu/Beginner A1/1- objective_enc_20131106_1.json")
    File.read!("/home/armin/Data/Development/Elixir/internet_prjoect/busuu/new_new/Beginner A1/1- objective_enc_20131106_1.json")
    |> Poison.decode!()
    |> Content.DataShaper.TranslationMap.do_translation()
    |> Content.DataShaper.Entity.do_entity()
    |> Content.DataShaper.Lesson.do_lesson()
    |> Content.DataShaper.LessonContent.do_lesson_content()
    |> for_every_unit()
    # link
    # |> Content.DataFetcher.fetch()
    # |> decode_response()
    # |> Content.DataShaper.TranslationMap.do_translation()
    # |> Content.DataShaper.Entity.do_entity()
    # |> Content.DataShaper.Unit.do_unit()
    # |> Content.DataShaper.UnitContent.do_unit_content()
    # |> Content.DataShaper.RootStruct.do_root_struct()
    # |> Content.DataShaper.LeafStruct.do_leaf_struct()
    # a["entity_map"]["entity__f1417409"]
  end

  defp for_every_unit(%{"id" => lesson_id, "structure" => units})do
    units
    |> Enum.map(&_start(lesson_id,&1))
  end

  defp _start(lesson_id, unit)do
    unit
    |> Content.DataShaper.Unit.do_unit(lesson_id)
    |> Content.DataShaper.UnitContent.do_unit_content()
    |> Content.DataShaper.RootStruct.do_root_struct()
    |> Content.DataShaper.LeafStruct.do_leaf_struct()
  end

  def decode_response({:ok , body}), do: body
  def decode_response({:error, error}) do
    IO.puts "Error fetching from busuu: #{error["message"]}"
    System.halt(2)
  end
end
