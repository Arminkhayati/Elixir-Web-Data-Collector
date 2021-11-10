defmodule Collector.URLCollector do

  require Logger
  import Floki
  import Collector.DataFetcher

  def collect(url)do
    case get(url)do
      {:ok, body} ->
        {_get_movies_url(body) , _next_page(body)}
      {:error, :timeout} ->
        collect(url)
      error ->
        Logger.error("**** Error in Collecting url with this page : #{url} \t #{inspect(error)}")
        collect(url)
    end
  end

  defp _next_page(body)do
    find(body, "link[rel=next]") |> attribute("href")
  end

  defp _get_movies_url(body) do
    find(body, "article.movie")
    |> find("a[rel=bookmark]")
    |> attribute("href")
    # |> Enum.map(&_remove_url_prefix/1)
  end

  # defp _remove_url_prefix("http://mydiba.site/" <> postfix)do
  #   postfix
  # end

end
