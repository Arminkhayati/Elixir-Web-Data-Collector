defmodule Collector.Repo.Migrations.ModifyArtistsTable do
  use Ecto.Migration

  def change do
    alter table(:artists)do
      add :sex, :string
      add :artist_role, :string
    end
  end
end
