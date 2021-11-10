defmodule Collector.Repo.Migrations.CreateArtistsTable do
  use Ecto.Migration

  def change do
    create table(:artists)do
      add :name, :string
      add :birthday, :string
      add :birthplace, :string
      add :score, :float
      add :imdb_link, :string
      add :awards, :text
      add :link, :string
    end
  end
end
