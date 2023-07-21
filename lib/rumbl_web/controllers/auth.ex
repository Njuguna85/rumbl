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

  import Phoenix.Controller
  alias RumblWeb.Router.Helpers, as: Routes
  def authenticate_user(conn, _opts) do
    # if there is a current user, return the connection unchanged
    # otherwise, store a flash message and redirect back to our application root
    # use halt(conn) to stop any downstream transformations
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access the page!")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
