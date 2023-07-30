defmodule PeerLearningWeb.Router do
  use PeerLearningWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PeerLearningWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug PeerLearningWeb.Plug.AuthAccessPipeline
  end

  scope "/", PeerLearningWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  scope "/api", PeerLearningWeb do
    pipe_through :api

    scope "/v1" do
      scope "/onboarding" do
        post "/register", UserController, :register
        post "/forgot-password", UserController, :forgot_password
        post "/reset-password", UserController, :reset_password
        post "/verify-user", UserController, :verify_user
      end

      post "/login", AuthController, :login
      post "/send_mail", AuthController, :send_mail

      # resources "/users", UserController, except: [:new, :edit]
      scope "/" do
        pipe_through :auth

        scope "/users" do
          put "/users/:id", UserProfileController, :update
          resources "/children", ChildrenController
          resources "/class-schedule-drafts", ClassScheduleDraftController
        end

        # admin routes
        get "/children", ChildrenController, :index
      end
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:peer_learning, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PeerLearningWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
