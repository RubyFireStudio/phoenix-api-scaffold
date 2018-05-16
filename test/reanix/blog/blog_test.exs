defmodule Reanix.BlogTest do
  use Reanix.DataCase

  alias Reanix.Blog

  describe "categories" do
    alias Reanix.Blog.Category

    @valid_attrs %{name: "some name", slug: "some-slug"}
    @update_attrs %{name: "some updated name", slug: "another-cool-slug"}
    @invalid_attrs %{name: nil, slug: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Blog.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Blog.get_category!(category.id) == category
    end

    test "get_category!/1 returns the category with given slug" do
      category = category_fixture()
      assert Blog.get_category!(category.slug) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = Blog.create_category(@valid_attrs)
      assert category.name == "some name"
      assert category.slug == "some-slug"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = Blog.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.name == "some updated name"
      assert category.slug == "another-cool-slug"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_category(category, @invalid_attrs)
      assert category == Blog.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Blog.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Blog.change_category(category)
    end
  end

  describe "posts" do
    alias Reanix.Blog.Post

    @valid_attrs %{announcement: "some announcement", body: "some body", image: "some image", publication_date: ~N[2010-04-17 14:00:00.000000], slug: "some slug", status: "some status", title: "some title"}
    @update_attrs %{announcement: "some updated announcement", body: "some updated body", image: "some updated image", publication_date: ~N[2011-05-18 15:01:01.000000], slug: "some updated slug", status: "some updated status", title: "some updated title"}
    @invalid_attrs %{announcement: nil, body: nil, image: nil, publication_date: nil, slug: nil, status: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      category = category_fixture()
      user = Reanix.AccountsTest.user_fixture()

      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{category_id: category.id, author_id: user.id})
        |> Blog.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "get_post!/1 returns the post with given slug" do
      post = post_fixture()
      assert Blog.get_post!(post.slug) == post
    end

    test "create_post/1 with valid data creates a post" do
      category = category_fixture()
      user = Reanix.AccountsTest.user_fixture()

      assert {:ok, %Post{} = post} =
        @valid_attrs
        |> Enum.into(%{category_id: category.id, author_id: user.id})
        |> Blog.create_post()
      assert post.announcement == "some announcement"
      assert post.body == "some body"
      assert post.image == "some image"
      assert post.publication_date == ~N[2010-04-17 14:00:00.000000]
      assert post.slug == "some slug"
      assert post.status == "some status"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Blog.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.announcement == "some updated announcement"
      assert post.body == "some updated body"
      assert post.image == "some updated image"
      assert post.publication_date == ~N[2011-05-18 15:01:01.000000]
      assert post.slug == "some updated slug"
      assert post.status == "some updated status"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
