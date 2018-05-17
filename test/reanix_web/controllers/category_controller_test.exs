defmodule ReanixWeb.CategoryControllerTest do
  use ReanixWeb.ConnCase

  alias Reanix.Blog.Category

  @create_attrs %{name: "some name", slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  describe "index" do
    test "lists all categories", %{conn: conn} do
      conn = get conn, category_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create category" do
    test "renders 401 when user is not authorized", %{conn: conn} do
      conn = post conn, category_path(conn, :create), category: @create_attrs
      assert json_response(conn, 401)["data"] != %{}
    end

    test "renders category when data is valid", %{auth_conn: conn} do
      conn = post conn, category_path(conn, :create), category: @create_attrs
      assert %{"id" => id, "slug" => slug} = json_response(conn, 201)["data"]

      conn = get conn, category_path(conn, :show, slug)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name",
        "slug" => slug,
        "posts" => []
      }
    end

    test "renders errors when data is invalid", %{auth_conn: conn} do
      conn = post conn, category_path(conn, :create), category: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "show category" do
    setup [:create_category, :create_post]

    test "renders category with post", %{conn: conn, post: post, category: %Category{id: id, slug: slug} = category} do
      conn = get conn, category_path(conn, :show, slug)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => category.name,
        "slug" => slug,
        "posts" => [
          %{
            "id" => post.id,
            "title" => post.title,
            "slug" => post.slug,
            "announcement" => post.announcement,
            "body" => post.body,
            "image" => post.image,
            "publication_date" => "2010-04-17T14:00:00.000000",
            "status" => post.status,
          }
        ]
      }
    end
  end

  describe "update category" do
    setup [:create_category]

    test "renders 401 when user is not authorized", %{conn: conn, category: category} do
      conn = put conn, category_path(conn, :update, category), category: @update_attrs
      assert json_response(conn, 401)["data"] != %{}
    end

    test "renders category when data is valid", %{auth_conn: conn, category: %Category{id: id} = category} do
      conn = put conn, category_path(conn, :update, category), category: @update_attrs
      assert %{"id" => ^id, "slug" => slug} = json_response(conn, 200)["data"]

      conn = get conn, category_path(conn, :show, slug)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name",
        "slug" => slug,
        "posts" => []
      }
    end

    test "renders errors when data is invalid", %{auth_conn: conn, category: category} do
      conn = put conn, category_path(conn, :update, category), category: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "renders 401 when user is not authorized", %{conn: conn, category: category} do
      conn = delete conn, category_path(conn, :delete, category)
      assert json_response(conn, 401)["data"] != %{}
    end

    test "deletes chosen category", %{auth_conn: conn, category: category} do
      conn = delete conn, category_path(conn, :delete, category)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, category_path(conn, :show, category)
      end
    end
  end

  defp create_category(_) do
    category = insert(:category)
    {:ok, category: category}
  end

  defp create_post(%{category: category}) do
    post = insert(:post, category: category)
    {:ok, post: post}
  end
end
