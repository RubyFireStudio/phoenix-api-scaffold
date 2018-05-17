defmodule ReanixWeb.CategoryView do
  use ReanixWeb, :view
  alias ReanixWeb.CategoryView
  alias ReanixWeb.PostView

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, CategoryView, "category.json")}
  end

  def render("change.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category_detail.json")}
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      slug: category.slug
    }
  end

  def render("category_detail.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      slug: category.slug,
      posts: render_many(category.posts, PostView, "post.json")
    }
  end
end
