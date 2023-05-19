defmodule RumblWeb.Router do
  use RumblWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RumblWeb do
    pipe_through :browser

    # the users route matches HTTP GET request to this url
    # and sends them to the user controller, calling
    # the index action
    get "/users", UserController, :index

    get "/users/:id", UserController, :show
    get "/", PageController, :index

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", RumblWeb do
  #   pipe_through :api
  # end
end
