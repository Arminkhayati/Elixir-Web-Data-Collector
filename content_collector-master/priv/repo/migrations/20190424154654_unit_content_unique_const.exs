defmodule Content.Repo.Migrations.UnitContentUniqueConst do
  use Ecto.Migration

  def change do
    create unique_index(:unit_contents, [:unit_id])
  end
end
