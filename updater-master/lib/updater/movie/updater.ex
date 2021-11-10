defmodule Updater.Movie.Updater do
  import Floki
  alias Updater.DataFetcher
  require Logger
  alias Updater.Movie.Moviedb

  def start(%{link: link})do
    fetch_movie_link(link)
    |> decode_movie()
    |> Map.put(:link, link)
    |> Moviedb.update()
  end

  def decode_movie(html)do
    %{
      imdb_score: find(html, "div.imdbrating_box_film") |> text([deep: false]) |> String.trim() |> to_num(),
      diba_score: find(html, "div.user_counts_box_film")|> text()|> String.split("/") |> List.first() |> String.trim()|> to_num(),

    }
  end

  def fetch_movie_link(url)do
    case DataFetcher.get(url)do
      {:ok, body} -> body
      {:error, :timeout} -> fetch_movie_link(url)
      error ->
        Logger.error("**** Error in get HTML with this page : #{url} \t #{inspect(error)}")
        fetch_movie_link(url)
    end
  end


  def to_num(nil), do: 0
  def to_num(num)do
    if String.match?(num, ~r{(\d+(\.\d+)?)})do
      if(String.contains?(num, "."), do: String.to_float(num), else: String.to_integer(num))
    else
      0
    end
  end



end
