defmodule Polyvox.Router do
  use Polyvox.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticated do
    plug Polyvox.Auth, repo: Polyvox.Repo
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  scope "/", Polyvox do
    pipe_through :browser

    get "/", ApplicationsController, :index
    resources "/applications", ApplicationsController
  end

  scope "/insiders", Polyvox do
    pipe_through [:browser, :authenticated]

    get "/", ApplicantController, :index
    resources "/applicants", ApplicantController, only: [:index, :delete]
    resources "/trading", InsiderTradingController, only: [:new, :create, :delete, :edit, :update]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Polyvox do
  #   pipe_through :api
  # end
end
