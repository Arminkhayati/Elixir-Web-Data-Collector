defmodule Content.Repo.Migrations.CreateLessonContentUniqueConst do
  use Ecto.Migration

  def change do
     create unique_index(:lesson_contents, [:lesson_id])
  end
end
