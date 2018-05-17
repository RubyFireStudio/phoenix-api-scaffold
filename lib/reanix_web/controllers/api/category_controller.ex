defmodule ReanixWeb.CategoryController do
  use ReanixWeb, :controller

  alias Reanix.Blog
  alias Reanix.Blog.Category

  action_fallback ReanixWeb.FallbackController

  plug :load_category when action in [:show, :update, :delete]

  def index(conn, _params) do
    categories = Blog.list_categories()
    render(conn, "index.json", categories: categories)
  end

  def create(conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <- Blog.create_category(category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", category_path(conn, :show, category))
      |> render("change.json", category: category)
    end
  end

  def show(%{assigns: %{category: category}} = conn, _) do
    render(conn, "show.json", category: category)
  end

  def update(%{assigns: %{category: category}} = conn, %{"category" => category_params}) do
    with {:ok, %Category{} = category} <- Blog.update_category(category, category_params) do
      render(conn, "change.json", category: category)
    end
  end

  def delete(%{assigns: %{category: category}} = conn, _) do
    with {:ok, %Category{}} <- Blog.delete_category(category) do
      send_resp(conn, :no_content, "")
    end
  end

  defp load_category(%{path_params: %{"slug" => slug}} = conn, _) do
    category = Blog.get_category!(slug)
    assign(conn, :category, category)
  end
end
