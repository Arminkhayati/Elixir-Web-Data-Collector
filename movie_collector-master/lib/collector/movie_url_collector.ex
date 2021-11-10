defmodule Collector.MovieUrlCollector do
  alias Collector.Server.URLCollector
  alias Collector.Repo

  def start()do
    {next? , url_list} = URLCollector.get_url_list()
    case next? do
      :last ->
        insert_all(url_list)
      :continues ->
        insert_all(url_list)
        start()
    end
  end

  def insert_all(url_list)do
    url_list = Enum.map(url_list, fn url -> %{link: url} end)
    Repo.insert_all("movies_links", url_list)
  end

end
