defmodule Collector.ArtistDecoder do
  import Floki

  def decode(html)do
    data = find(html, "div.person-bar") |> find("span")
    %{
      name: get(data, 0) |> text() |> String.split(" : ")|> List.last() |> String.trim(),
      birthday: get(data, 1) |> text() |> String.split(" : ")|> List.last() |> String.trim(),
      birthplace: get(data, 2) |> text() |> String.split(" : ")|> List.last() |> String.trim(),
      score: get(data, 3) |> text() |> String.split(" : ")|> List.last() |> String.trim() |> to_num(),
      imdb_link: get(data, 4) |> find("a.icon-IMDb") |> attribute("href") |> List.first(),
      awards: find(html, "div.person_awards") |> text(sep: " || "),
      # link: ,
    }
  end

  def get([], _i), do: ""
  def get([head | _tail], 0), do: head
  def get([_ | tail], i), do: get(tail, i-1)

  def to_num(nil), do: 0
  def to_num(num)do
    if String.match?(num, ~r{(\d+(\.\d+)?)})do
      if(String.contains?(num, "."), do: String.to_float(num), else: String.to_integer(num))
    else
      0
    end
  end
end
