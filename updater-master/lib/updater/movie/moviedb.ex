defmodule Updater.Movie.Moviedb do
  import Ecto.Query
  alias Updater.Movie.Repo

  def get_all()do
    query =
      from m in "movies",
       where: m.imdb_score == 0 or m.diba_score == 0,
       select: %{link: m.link, imbd_score: m.imdb_score, diba_score: m.diba_score}
    Repo.all(query)
  end

  def update(%{link: link, imdb_score: imdb_score, diba_score: diba_score})do
    query = from m in "movies",
     where: m.link == ^link,
     update: [set: [diba_score: ^diba_score, imdb_score: ^imdb_score]]
    Repo.update_all(query, [])
  end

end
