defmodule Content.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def change do

    create table(:units, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :unit_id, :string
      add :class, :string
      add :type, :string
      add :time_estimate, :integer
    end

    create unique_index(:units, [:unit_id], name: :units_id_unique_constraint)

    create table(:unit_contents, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :image1024, :string
      add :image2048, :string
      add :unit_id, references(:units, [column: :id, type: :uuid])
    end


    create table(:root_structs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :struct_id, :string
      add :class, :string
      add :type, :string
      add :icon, :string
      add :unit_id, references(:units, [column: :id, type: :uuid])
    end

    create unique_index(:root_structs, [:struct_id], name: :struct_id_unique_constraint)

    create table(:leaf_structs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :struct_id, :string
      add :class, :string
      add :type, :string
      add :content, :string # -> :text
      add :root_id, references(:root_structs, [column: :id, type: :uuid])
    end

    create table(:translations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :str_key, :string
      add :value, :string     # -> :text
      add :audio, :string
      add :alternative_value, :string
      add :has_audio, :boolean
    end

    create unique_index(:translations, [:str_key], name: :trans_key_unique_constraint)

    create table(:entities, primary_key: false)do
      add :id, :uuid, primary_key: true
      add :entity_key, :string
      add :phrase, references(:translations, [column: :id, type: :uuid])
      add :image, :string
      add :vocabulary, :boolean
    end
    create unique_index(:entities, [:entity_key], name: :entity_key_unique_constraint)

    create table(:entity_images, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :entity_key, references(:entities, [column: :id, type: :uuid])
      add :small, :string
      add :medium, :string
      add :large, :string
      add :xlarge, :string
    end

    create table(:entity_videos, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :entity_id, references(:entities, [column: :id, type: :uuid])
      add :type, :string
      add :size, :string
      add :link, :string
    end






  end
end
