defmodule Reanix.Factory do
  use ExMachina.Ecto, repo: Reanix.Repo

  def user_factory do
    %Reanix.Accounts.User{
      name: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@example.com"),
      username: sequence(:username, &"username-#{&1}"),
      password_hash: "somehash"
    }
  end

  def category_factory do
    %Reanix.Blog.Category{
      name: sequence(:slug, &"name-#{&1}"),
      slug: sequence(:slug, &"slug-#{&1}")
    }
  end

  def post_factory do
    %Reanix.Blog.Post{
      announcement: "some announcement",
      body: "some body",
      image: "some image",
      publication_date: ~N[2010-04-17 14:00:00.000000],
      slug: "some slug",
      status: "some status",
      title: "some title",
      author: insert(:user),
      category: insert(:category)
    }
  end
end
