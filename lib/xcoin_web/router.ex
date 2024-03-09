defmodule XcoinWeb.Router do
  use XcoinWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Xcoin.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", XcoinWeb do
    pipe_through [:api, :auth]

    post "/users", UserController, :create
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/api", XcoinWeb do
    pipe_through [:api, :auth, :ensure_auth]

    get "/users/:id", UserController, :show
  end
end
