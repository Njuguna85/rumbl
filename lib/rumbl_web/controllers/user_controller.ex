defmodule RumblWeb.UserController do
  # This is a module under the rumble_web
  # the use injects the rumbl web controller

  use RumblWeb, :controller

  alias Rumbl.Accounts
  plug :authenticate when action in [:index, :show]
  alias Rumbl.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  # show action
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    # this receives a struct and returns an Ecto.Changeset
    changeset = Accounts.change_registration(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: Routes.user_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp authenticate(conn, _opts) do
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
end
