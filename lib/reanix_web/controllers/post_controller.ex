defmodule ReanixWeb.PostController do
  use ReanixWeb, :controller

  alias Reanix.Blog
  alias Reanix.Blog.Post

  action_fallback ReanixWeb.FallbackController

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    user = Reanix.Accounts.get_current_user(conn)
    post_params = Enum.into(post_params, %{"author_id" => user.id})

    with {:ok, %Post{} = post} <- Blog.create_post(post_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", post_path(conn, :show, post))
      |> render("show.json", post: post)
    end
  end

  def show(conn, %{"slug" => slug}) do
    post = Blog.get_post!(slug)
    render(conn, "show.json", post: post)
  end
  def show(conn, %{"id" => id}) do
    post = Blog.get_post!(id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id} = params) do
    post = Blog.get_post!(id)
    update(conn, params, post)
  end
  def update(conn, %{"slug" => slug} = params) do
    post = Blog.get_post!(slug)
    update(conn, params, post)
  end
  def update(conn, %{"post" => post_params}, %Post{} = post) do
    user = Reanix.Accounts.get_current_user(conn)
    post_params = Enum.into(post_params, %{"author_id" => user.id})

    with {:ok, %Post{} = post} <- Blog.update_post(post, post_params) do
      render(conn, "show.json", post: post)
    end
  end

  def delete(conn, %{"slug" =>  slug}) do
    post = Blog.get_post!(slug)
    with {:ok, %Post{}} <- Blog.delete_post(post) do
      send_resp(conn, :no_content, "")
    end
  end
end
