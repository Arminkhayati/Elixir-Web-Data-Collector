defmodule Collector.MovieCollector do
  alias Collector.Schema.Movies
  alias Collector.DataFetcher
  alias Collector.{MovieDecoder, CommentDecoder}
  require Logger
  # import Collector.Schema.Comments
  # import Collector.Schema.Movies
  alias Collector.Server.DBController

  def start()do
    get_html()
    |> start_decode()
  end

  def start_decode(:done), do: :done
  def start_decode({url, html})do
    movie = MovieDecoder.decode(html) |> Map.put(:link, url)
    IO.inspect(movie)
    comments = CommentDecoder.decode(html)
    # {url, %{movie: :ok, comments: :ok}}
    {url, DBController.add_data(movie, comments)}
  end

  def get_html()do
    {:ok, url} = DBController.get_one_movie()
    case fetch_url(url)do
      :done -> :done
      {:ok, body} -> {url, body}
      {:error, :timeout} -> get_html()
      error ->
        Logger.error("**** Error in get HTML with this page : #{url} \t #{inspect(error)}")
        get_html()
    end
  end

  def fetch_url(nil), do: :done
  def fetch_url(url), do: DataFetcher.get(url)



end
