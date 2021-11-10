defmodule Collector.MovieDecoder do

# {_, html1} = Collector.DataFetcher.get "http://mydiba.site/series/tt7366338/"
# {_, html} = Collector.DataFetcher.get "http://mydiba.site/tt6483364/"
# Collector.MovieDecoder.decode html
  import Floki

  def decode(html)do
    %{
      name: find(html, "div.title_box_film") |> text()|> String.replace("دانلود فیلم", "") |> String.split() |> check_name(html) ,
      year: find(html, "div.title_box_film") |> text()|> String.replace("دانلود فیلم", "") |> String.split() |> List.last() |> to_num,
      genre: find(html, "div.genre_box_film") |> find("a[rel=tag]")|> text([sep: ", "]) |> String.split(", "),
      age: find(html, "span.box_rated") |> text() |> String.trim(),
      imdb_score: find(html, "div.imdbrating_box_film") |> text([deep: false]) |> String.trim() |> to_num(),
      imdb_voters: find(html, "div.votes_box_film") |> text([deep: false])|> String.split() |> List.last()|>String.replace(",","") |> to_num,
      imdb_link: find(html, "div.imdb_box_film") |> find("a[rel=nofollow]")  |> attribute("href")|> text(),
      diba_score: find(html, "div.user_counts_box_film")|> text()|> String.split("/") |> List.first() |> String.trim()|> to_num(),
      diba_voters: find(html, "div.user_counts_box_film")|> text()|> String.split("(")|> List.last() |> String.split("کاربر")|> List.first() |> String.trim()|> to_num,
      quality: find(html, "div.quality_box_film") |> text() |> String.trim(),
      critics_score: find(html, "span.-critics-score") |> text() |> String.trim() |> to_num(),
      country: find(html, "div.-ry") |> find("span")|> text()|> String.replace("|", "") |> String.split() ,
      total_sell: find(html, "div.-budget") |> find("span")|> text() |> String.replace("-","")|> String.replace("$","") |> String.trim(),
      duration: find(html, "div.-sale") |> find("span")|> text() |> String.split() |> List.first(),
      description: find(html, "section.box-movie-description") |> find("p.text-justify")|> text()|> String.trim(),
      director: find(html, "div.col-xs-4") |> find("span.m-r-5") |> find("a[rel=tag]") |> text()|> String.trim(),
      director_url: find(html, "div.col-xs-4") |> find("span.m-r-5") |> find("a[rel=tag]") |> attribute("href")|> text(),
      actors: find(html, "div.col-xs-8") |> find("span.m-r-5") |> find("a[rel=tag]")|> text(sep: " , ") |> String.split(" , "),
      actors_url: find(html, "div.col-xs-8") |> find("span.m-r-5") |> find("a[rel=tag]") |> attribute("href")|> text(sep: " , ")|> String.split(" , "),
      dubbed: find(html, "section.dubbed-single") |> text() |> String.trim(), #!= "",
      # comments: Collector.CommentDecoder.decode(html)
      movie_id: get_movie_id(html)
    }
  end

  def check_name([],html ), do: find(html, "title")|> List.first() |> text()
  def check_name(name, _)do
    name |> Enum.reverse() |> tl() |> Enum.reverse()|> Enum.join(" ") |> String.trim()
  end

  def to_num(nil), do: 0
  def to_num(num)do
    if String.match?(num, ~r{^[0-9]+$})do
      if(String.contains?(num, "."), do: String.to_float(num), else: String.to_integer(num))
    else
      0
    end
  end

  def get_movie_id(html)do
    html
    |> find("span.sl-wrapper")
    |> find("a.sl-button")
    |> attribute("href")
    |> text()
    |> URI.decode_query()
    |> Map.get("post_id")
  end


end
