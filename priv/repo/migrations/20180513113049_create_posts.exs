defmodule Reanix.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :announcement, :text
      add :body, :text
      add :image, :string
      add :slug, :string
      add :publication_date, :naive_datetime
      add :status, :string
      add :category_id, references(:categories, on_delete: :nothing)
      add :author_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:category_id])
    create index(:posts, [:author_id])
    create unique_index(:posts, [:slug])
  end
end
