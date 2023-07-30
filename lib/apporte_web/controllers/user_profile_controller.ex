defmodule PeerLearningWeb.UserProfileController do
  use PeerLearningWeb, :controller

  alias PeerLearning.Accounts
  alias PeerLearning.Accounts.UserProfile

  action_fallback PeerLearningWeb.FallbackController

  def index(conn, _params) do
    user_profiles = Accounts.list_user_profiles()
    render(conn, :index, user_profiles: user_profiles)
  end

  def create(conn, %{"user_profile" => user_profile_params}) do
    with {:ok, %UserProfile{} = user_profile} <- Accounts.create_user_profile(user_profile_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/user_profiles/#{user_profile}")
      |> render(:show, user_profile: user_profile)
    end
  end

  def show(conn, %{"id" => id}) do
    user_profile = Accounts.get_user_profile!(id)
    render(conn, :show, user_profile: user_profile)
  end

  def update(conn, %{"id" => user_id, "user_profile" => user_profile_params}) do
    with {:ok, %UserProfile{} = user_profile} <-
           Accounts.update_user_profile(user_id, user_profile_params) do
      render(conn, :show, user_profile: user_profile)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_profile = Accounts.get_user_profile!(id)

    with {:ok, %UserProfile{}} <- Accounts.delete_user_profile(user_profile) do
      send_resp(conn, :no_content, "")
    end
  end
end
