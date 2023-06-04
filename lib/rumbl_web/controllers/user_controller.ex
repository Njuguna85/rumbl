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

  # show action
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

end
