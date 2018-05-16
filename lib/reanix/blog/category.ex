defmodule Reanix.Blog.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Reanix.Blog.Category


  @derive {Phoenix.Param, key: :slug}
  schema "categories" do
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:slug)
  end
end
