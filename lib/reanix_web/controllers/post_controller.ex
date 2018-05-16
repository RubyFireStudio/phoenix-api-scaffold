defmodule ReanixWeb.PostController do
  use ReanixWeb, :controller

  alias Reanix.Blog
  alias Reanix.Blog.Post

  action_fallback ReanixWeb.FallbackController

  plug :load_user
  plug :load_post when action in [:show, :update, :delete]
  plug :ensure_author when action in [:update, :delete]

  # Actions

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(%{assigns: %{user: user}} = conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Blog.create_post_by_user(user, post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(%{assigns: %{post: post}} = conn, _) do
    render(conn, "show.json", post: post)
  end

  def update(%{assigns: %{post: post}} = conn, %{"post" => post_params}) do
    with {:ok, %Post{} = post} <- Blog.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(%{assigns: %{post: post}} = conn, _) do
    with {:ok, %Post{}} <- Blog.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end

  # Private functions

  defp load_user(conn, _) do
    user = Reanix.Accounts.get_current_user(conn)
    assign(conn, :user, user)
  end
  
  defp load_post(%{path_params: %{"slug" => slug}} = conn, _) do
    post = Blog.get_post!(slug)
    assign(conn, :post, post)
  end

  defp load_post(%{path_params: %{"id" => id}} = conn, _) do
    post = Blog.get_post!(id)
    assign(conn, :post, post)
  end

  defp ensure_author(conn, _) do
    if conn.assigns.user.id == conn.assigns.post.author_id do
      conn
    else
      conn
      |> ReanixWeb.FallbackController.call({:error, :forbidden})
      |> halt()
    end
  end
end
