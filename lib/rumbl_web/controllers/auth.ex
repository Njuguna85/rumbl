defmodule RumblWeb.Auth do
  import Plug.Conn

  # allows for compile time options
  def init(opts), do: opts

  def call(conn, _opts) do
    # check if there is a user id store in the session
    #  assign a user to the connection, thus the current user is available
    # downstream function including controllers and views
    user_id = get_session(conn, :user_id)
    user = user_id && Rumbl.Accounts.get_user(user_id)

    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end
end
