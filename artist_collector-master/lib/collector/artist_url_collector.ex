defmodule Collector.ArtistUrlCollector do
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
    url_list = Enum.map(url_list, fn url ->
       %{link: url, collected: false, sex: "male", artist_role: "director"} end)
    Repo.insert_all("artists_links", url_list)
  end

end
