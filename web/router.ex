defmodule Polyvox.Router do
  use Polyvox.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", Polyvox do
    pipe_through :browser

    resources "/applications", ApplicationController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Polyvox do
  #   pipe_through :api
  # end
end
