defmodule Collector.Repo.Migrations.CreateMovieTable do
  use Ecto.Migration

  def change do
    alter table(:movies_links)do
      add :collected, :boolean, default: false
    end

    alter table(:movies)do
      add :link, :string
    end
    
  end
end
