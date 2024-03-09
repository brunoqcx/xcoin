defmodule XcoinWeb.Router do
  use XcoinWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", XcoinWeb do
    pipe_through :api
  end
end
