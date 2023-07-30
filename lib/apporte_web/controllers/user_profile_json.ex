defmodule PeerLearningWeb.UserProfileJSON do
  alias PeerLearning.Accounts.UserProfile

  @doc """
  Renders a list of user_profiles.
  """
  def index(%{user_profiles: user_profiles}) do
    %{data: for(user_profile <- user_profiles, do: data(user_profile))}
  end

  @doc """
  Renders a single user_profile.
  """
  def show(%{user_profile: user_profile}) do
    %{data: data(user_profile)}
  end

  def data(%UserProfile{} = user_profile) do
    %{
      id: user_profile.id,
      fullname: user_profile.fullname,
      dob: user_profile.dob,
      gender: user_profile.gender,
      state_province_of_origin: user_profile.state_province_of_origin,
      address: user_profile.address,
      country: user_profile.country
    }
  end
end
