defmodule Content.Repo.Migrations.CreateLessonTable do
  use Ecto.Migration

  def change do
    create table(:lessons, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :lesson_id, :string
      add :type, :string
      add :class, :string
    end
    create unique_index(:lessons, [:lesson_id], name: :lesson_id_unique_constraint)

    alter table(:units)do
      add :lesson_id, references(:lessons, [column: :id, type: :uuid])
    end
  end
end
