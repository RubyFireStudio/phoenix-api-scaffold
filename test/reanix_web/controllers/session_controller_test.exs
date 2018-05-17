defmodule ReanixWeb.SessionControllerTest do
  use ReanixWeb.ConnCase

  alias Reanix.Accounts
  alias Reanix.Accounts.User

  @user_attr %{
    "name" => "Name",
    "username" => "Username",
    "email" => "test@example.com",
    "password" => "123456"
  }

  describe "create session" do
    setup [:create_user]

    test "with valid email and password renders user with jwt", %{
      conn: conn, user: %User{id: id} = user
    } do
      conn = post conn, session_path(conn, :create), @user_attr

      assert %{"data" => data, "meta" => meta} = json_response(conn, 201)

      assert %{"token" => _} = meta
      assert Map.drop(data, ["last_login"]) == %{
         "id" => id,
         "name" => user.name,
         "username" => user.username,
         "email" => "test@example.com",
         "is_staff" => false,
         "is_superuser" => false
       }
    end

    test "with invalid password renders 403", %{conn: conn} do
      conn = post conn, session_path(conn, :create), %{"email" => "invalid", "password" => "incorrect"}

      assert json_response(conn, 422)["errors"] == "Wrong email or password"
    end
  end

  defp create_user(_) do
    {:ok, user} = Accounts.create_user(@user_attr)
    {:ok, user: user}
  end
end
