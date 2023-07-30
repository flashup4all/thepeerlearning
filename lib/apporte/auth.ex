defmodule PeerLearning.Auth do
  @moduledoc false
  require Logger

  alias PeerLearning.Accounts.{User, UserToken, UserProfile, Children}
  alias PeerLearningWeb.Validators.{RegisterUser}
  alias PeerLearning.Repo
  alias PeerLearningWeb.Auth.Guardian

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(%RegisterUser{parent: parent, child: child, user: user} = _params) do
    Repo.transaction(fn ->
      with {:ok, %User{} = user} <-
             User.create_user(Map.from_struct(%{user | email: String.downcase(user.email)})),
           {:ok, %UserProfile{} = user_profile} <-
             UserProfile.create_user_profile(user, Map.from_struct(parent)),
           Children.create_child(user, Map.from_struct(child)),
           {:ok, user_token} <- UserToken.create_user_token(user, "email_verification") do
        [first_name | last_name] = split_fullname(user_profile.fullname)

        PeerLearningEvents.email_service_deliver_email_confirmation(%{
          "type" => "deliver_email_verification",
          "payload" => %{
            "hashed_token" => Base.url_encode64(user_token.token, padding: false),
            "email" => user.email,
            "first_name" => first_name,
            "last_name" => last_name
          }
        })

        Repo.preload(user, [:user_profile])
      else
        {:error, error} ->
          Repo.rollback(error)

        error ->
          error
      end
    end)
  end

  def verify_user(token, email) do
    Repo.transaction(fn ->
      with {:ok, user} <- User.get_user_by_email(email),
           {:ok, user_token} <- UserToken.verify_email_token(user, token, "email_verification"),
           {:ok, user} <- User.update_user(user, %{is_email_verified: true, is_active: true}),
           {:ok, _user_profile} <- UserProfile.get_user_profile_by_user_id(user.id),
           {:ok, _updated} <- UserToken.update_status(user_token, :inactive) do
        # [first_name | last_name] = split_fullname(user_profile.fullname)

        user
      else
        {:error, error} ->
          Repo.rollback(error)
          {:error, error}

        error ->
          Repo.rollback(error)
          {:error, error}
      end
    end)
  end

  def login(email, password) do
    with {:ok, user} <- User.get_user_by_email(String.downcase(email)),
         {true, :verify_pass} <- {User.verify_password(user, password), :verify_pass},
         {:ok, user_profile} <- UserProfile.get_user_profile_by_user_id(user.id),
         {:ok, token, _claims} <-
           Guardian.encode_and_sign(user, token_type: "auth") do
      {:ok, %{user: %{user | user_profile: user_profile}, token: token}}
    else
      {false, :verify_pass} ->
        # Logger.warn("App.Auth - failed to verify email/password")

        changeset =
          %User{}
          |> Ecto.Changeset.cast(_params = %{}, [:email, :password])
          |> Ecto.Changeset.add_error(:email, "email/password do not match")
          |> Ecto.Changeset.add_error(:password, "email/password do not match")

        {:error, changeset}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}

      {:error, :not_found} ->
        # Logger.warn("App.Auth - User with email not found")
        {:error, :custom, :bad_request, "Error", "Email/Passwords do not match"}

      error ->
        {:error, :custom}
    end
  end

  @callback send_forgot_password_url(String.t()) ::
              {:ok, map()} | {:error, term() | Ecto.Changeset.t()} | no_return
  def send_forgot_password_url(email) do
    with {:ok, user} <- User.get_user_by_email(email),
         {:ok, user_profile} <- UserProfile.get_user_profile_by_user_id(user.id),
         _ <- UserToken.deactivate_all(user),
         {:ok, user_token} <- UserToken.create_user_token(user, "reset_password") do
      [first_name | last_name] = split_fullname(user_profile.fullname)

      PeerLearningEvents.email_service_deliver_forgot_password_url(%{
        "type" => "deliver_forgot_password_url",
        "payload" => %{
          "hashed_token" => Base.url_encode64(user_token.token, padding: false),
          "email" => user.email,
          "first_name" => first_name,
          "last_name" => last_name
        }
      })

      Logger.info("sent forgot_password_url to #{inspect(email)}")
      {:ok, user_token}
    else
      {:error, error} ->
        {:error, :custom, :unprocessable_entity, "VALIDATION_ERROR",
         "Couldn't process forgot password, plelase try again"}
    end
  end

  def reset_password(token, email, params) do
    Repo.transaction(fn ->
      with {:ok, user} <- User.get_user_by_email(email),
           {:ok, user_profile} <- UserProfile.get_user_profile_by_user_id(user.id),
           {:ok, user_token} <- UserToken.verify_email_token(user, token, "reset_password"),
           {:ok, user} <-
             User.update_user_password(user, params),
           {:ok, _updated} <- UserToken.update_status(user_token, :inactive) do
        [first_name | last_name] = split_fullname(user_profile.fullname)

        PeerLearningEvents.email_service_deliver_updated_password_mail(%{
          "type" => "deliver_updated_password_mail",
          "payload" => %{
            "email" => user.email,
            "first_name" => first_name,
            "last_name" => last_name
          }
        })

        user
      else
        {:error, error} ->
          Repo.rollback(error)
          {:error, error}

        error ->
          Repo.rollback(error)
          {:error, error}
      end
    end)
  end

  defp split_fullname(fullname), do: String.split(fullname, " ")
end
