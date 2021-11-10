defmodule Content.Repo.Migrations.DropUploadsTable do
  use Ecto.Migration

  def change do
    drop table(:uploads)
  end
end
