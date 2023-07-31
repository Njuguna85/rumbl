defmodule RumblWeb.Auth do
  import Plug.Conn

  # allows for compile time options
  def init(opts), do: opts

  def call(conn, _opts) do
    # check if there is a user id store in the session
    #  assign a user to the connection, thus the current user is available
    # downstream function including controllers and views
    user_id = get_session(conn, :user_id)

    cond do
      # if current_user exists then put_current_user is called with the existing user
      user = conn.assigns[:current_user] -> put_current_user(conn, user)
      # if user_id is not nill and get_user return a valid user,
      # put_current_user is called with the retrieved user
      # the && operator return the second expression only if the first expression isn't falsy ie if the user_id is not nil, it proceeds to get_user and assigns it user variable
      user = user_id && Rumbl.Accounts.get_user(user_id) -> put_current_user(conn, user)
      true -> assign(conn, :current_user, nil)
    end
  end

  # place a freshly generated user token and current_user into
  # conn.assigns
  # anytime a user session exists both the current_user
  # and user_token will be set

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "User Socket", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
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
    |> put_current_user(user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
