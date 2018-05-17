defmodule ReanixWeb.PostControllerTest do
  use ReanixWeb.ConnCase

  alias Reanix.Blog.Post

  @create_attrs %{announcement: "some announcement", body: "some body", image: "some image", publication_date: ~N[2010-04-17 14:00:00.000000], slug: "some slug", status: "some status", title: "some title"}
  @update_attrs %{announcement: "some updated announcement", body: "some updated body", image: "some updated image", publication_date: ~N[2011-05-18 15:01:01.000000], slug: "some updated slug", status: "some updated status", title: "some updated title"}
  @invalid_attrs %{announcement: nil, body: nil, image: nil, publication_date: nil, slug: nil, status: nil, title: nil}

  setup do
    [category: insert(:category)]
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get conn, post_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create post" do
    test "not create post for unauthorized", %{conn: conn} do
      conn = post conn, post_path(conn, :create), post: @create_attrs
      assert json_response(conn, 401)
    end

    test "create post when data is valid and admin", %{auth_conn: conn, category: category} do
      conn = post conn, post_path(conn, :create), post: Enum.into(@create_attrs, %{category_id: category.id})
      assert %{"id" => id, "slug" => slug} = json_response(conn, 201)["data"]

      conn = get conn, post_path(conn, :show, slug)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "announcement" => "some announcement",
        "body" => "some body",
        "image" => "some image",
        "publication_date" => "2010-04-17T14:00:00.000000",
        "slug" => slug,
        "status" => "some status",
        "title" => "some title"}
    end

    test "renders errors when data is invalid", %{auth_conn: conn} do
      conn = post conn, post_path(conn, :create), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update post" do
    setup [:create_post]

    test "renders post when data is valid", %{conn: conn, post: %Post{id: id} = post} do
      conn = Reanix.Accounts.sign_in_user(conn, Reanix.Accounts.get_user!(post.author_id))
      conn = put conn, post_path(conn, :update, post), post: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, post_path(conn, :show, "some updated slug")
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "announcement" => "some updated announcement",
        "body" => "some updated body",
        "image" => "some updated image",
        "publication_date" => "2011-05-18T15:01:01.000000",
        "slug" => "some updated slug",
        "status" => "some updated status",
        "title" => "some updated title"}
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = Reanix.Accounts.sign_in_user(conn, Reanix.Accounts.get_user!(post.author_id))
      conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders 403 without permissions", %{conn: conn, post: post} do
      conn = Reanix.Accounts.sign_in_user(conn, insert(:user))
      conn = put conn, post_path(conn, :update, post), post: @update_attrs
      assert json_response(conn, 403)["errors"] != %{}
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = Reanix.Accounts.sign_in_user(conn, Reanix.Accounts.get_user!(post.author_id))
      conn = delete conn, post_path(conn, :delete, post)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, post_path(conn, :show, post)
      end
    end

    test "renders 403 without permissions", %{conn: conn, post: post} do
      conn = Reanix.Accounts.sign_in_user(conn, insert(:user))
      conn = delete conn, post_path(conn, :delete, post)
      assert json_response(conn, 403)["errors"] != %{}
    end
  end

  defp create_post(_) do
    post = insert(:post)
    {:ok, post: post}
  end
end
