defmodule RumblWeb.UserController do
  """
    This is a module under th rumble_web
    the use injects the rumbl web controller
  """
  use RumblWeb, :controller

  alias Rumbl.Accounts

  def index(conn, _params) do
    users =  Accounts.list_users()
    render(conn, "index.html", users: users)
  end
end
