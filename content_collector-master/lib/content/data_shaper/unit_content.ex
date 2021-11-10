defmodule Content.DataShaper.UnitContent do
  alias Content.Schema.UnitContent
  import Content.Downloader, only: [download: 1]
  def do_unit_content(json = %{"content" => data})do
    data
    |> map_to_schema()
    |> set_unit(json)
    |> UnitContent.to_db()
    json
  end

  def set_unit(content, json)do
    Map.put_new(content, :unit, json["id"])
  end
  def map_to_schema(data) do
    %{
      title: data["title"],
      image1024: download(data["images"]["tile_1024"]),
      image2048: download(data["images"]["fullscreen_2048"]),
    }
  end

end
