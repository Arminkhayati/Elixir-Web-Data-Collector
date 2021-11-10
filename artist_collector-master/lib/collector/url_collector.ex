defmodule Collector.URLCollector do

  require Logger
  import Floki
  import Collector.DataFetcher

  # {_, html} = Collector.DataFetcher.get
  def collect(url)do
    case get(url)do
      {:ok, body} ->
        {_get_artists_url(body) , _next_page(body)}
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

  defp _get_artists_url(body) do
    find(body, "div.more-actor-film")
    |> find("a[rel=bookmark]")
    |> attribute("href")
  end

end
