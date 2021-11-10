defmodule Content.Repo.Migrations.CreateLessonContentTable do
  use Ecto.Migration

  def change do
     create table(:lesson_contents, primary_key: false) do
       add :id, :uuid, primary_key: true
       add :lesson_id, references(:lessons, [column: :id, type: :uuid])
       add :title, :text
       add :image, :string
       add :image_svg, :string
       add :thumbnail_256, :string
       add :description, :text
       add :color1, :string
       add :color2, :string
       add :bucket, :integer
     end
  end

end
