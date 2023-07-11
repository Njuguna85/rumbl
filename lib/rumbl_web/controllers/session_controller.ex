defmodule RumblWeb.SessionController do
  use RumblWeb, :controller
  # this line imports and injects Phoenix controller related functionality
  # it provides pre-defined functions and macros such as
  # render, redirect and put_flash

  # handle a new action
  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case Rumbl.Accounts.authenticate_by_username_and_pass(username, pass) do
      {:ok, user} ->
        conn
        |> RumblWeb.Auth.login(user)
        |> put_flash(:info, "Welcome Back!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid Username/Password combination")
        |> render("new.html")
    end
  end
end
