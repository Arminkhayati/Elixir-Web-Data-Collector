defmodule Colelctor.ImTired do
  import Ecto.Query
  alias Collector.Repo
  def start()do
    query = from a in "artists_links", select: %{url: a.link, sex: a.sex, role: a.artist_role}
    artists = Collector.Repo.all(query)
    Enum.each(artists, &fetch_and_insert/1)
  end

  def fetch_and_insert(%{url: url, sex: sex, role: role})do
    {:ok, html} = Collector.DataFetcher.get(url)
    artist = Collector.ArtistDecoder.decode(html)
     |> Map.put(:link, url)
     |> Map.put(:sex, sex)
     |> Map.put(:artist_role, role)
    Repo.insert_all("artists", [artist])
  end

end
