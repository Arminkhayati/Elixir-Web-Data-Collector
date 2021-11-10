defmodule Content.Repo.Migrations.ModifyLessonTable do
  use Ecto.Migration

  def change do
    alter table(:lessons)do
      add :level, :string
    end
  end
end
