defmodule Collector.Repo.Migrations.CreateLinkTable do
  use Ecto.Migration

  def change do
    create table(:artists_links)do
      add :link, :string
      add :collected, :boolean, default: false
      add :sex, :string
      add :artist_role, :string
    end
  end
end
