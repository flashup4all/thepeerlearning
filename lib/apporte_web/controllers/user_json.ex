defmodule PeerLearningWeb.UserJSON do
  alias PeerLearning.Accounts.User
  alias PeerLearningWeb.UserProfileJSON
  alias PeerLearningWeb.ChildrenJSON

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  @doc """
  Renders a token.
  """
  def user_token(%{token: token}) do
    %{
      data: %{
        token: token
      }
    }
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      user_type: user.user_type,
      role: user.role,
      phone_number: user.phone_number,
      is_active: user.is_active,
      is_bvn_verified: user.is_bvn_verified,
      bvn: user.bvn,
      metadata: user.metadata,
      deleted_at: user.deleted_at,
      is_email_verified: user.is_email_verified,
      is_phone_number_verified: user.is_phone_number_verified,
      registration_step: user.registration_step,
      user_profile:
        if(Ecto.assoc_loaded?(user.user_profile),
          do: UserProfileJSON.data(user.user_profile),
          else: nil
        ),
      children:
        if(Ecto.assoc_loaded?(user.children),
          do: ChildrenJSON.index_from_assoc(%{children: user.children}),
          else: nil
        )
    }
  end
end
