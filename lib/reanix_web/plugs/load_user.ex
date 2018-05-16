if Code.ensure_loaded?(Plug) do
  defmodule ReanixWeb.Plug.LoadUser do
    @moduledoc """
    Plug to load user into assign.
    """

    import Plug.Conn

    alias Reanix.Accounts

    def init(opts), do: opts

    def call(conn, _) do
      user = Accounts.get_current_user(conn)
      assign(conn, :user, user)
    end
  end
end