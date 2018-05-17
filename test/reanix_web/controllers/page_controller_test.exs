defmodule ReanixWeb.PageControllerTest do
  use ReanixWeb.ConnCase

  setup do
    {:ok, conn: build_conn()}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200)
  end
end
