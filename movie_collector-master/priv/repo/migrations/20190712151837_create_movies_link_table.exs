defmodule Collector.Repo.Migrations.CreateMoviesLinkTable do
  use Ecto.Migration

  def change do
    create table(:movies_links)do
      add :link, :string
    end
  end
end
