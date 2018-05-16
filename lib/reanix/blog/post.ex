defmodule Reanix.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reanix.Blog.Post


  @derive {Phoenix.Param, key: :slug}
  schema "posts" do
    field :announcement, :string
    field :body, :string
    field :image, :string
    field :publication_date, :naive_datetime
    field :slug, :string
    field :status, :string
    field :title, :string
    field :category_id, :id
    field :author_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :announcement, :body, :image, :slug, :publication_date, :status, :author_id, :category_id])
    |> validate_required([:title, :announcement, :body, :image, :slug, :publication_date, :status, :author_id, :category_id])
    |> unique_constraint(:slug)
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:author_id)
  end
end
