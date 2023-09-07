defmodule PeerLearningWeb.UserController do
  use PeerLearningWeb, :controller

  alias PeerLearning.{Accounts, Auth, Repo}

  alias PeerLearning.Accounts.User
  alias PeerLearningWeb.Validators.{RegisterUser, EmailValidator, ResetPassword}
  alias PeerLearningWeb.Auth.Guardian

  action_fallback PeerLearningWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def register(conn, params) do
    with {:ok, validated_params} <- RegisterUser.cast_and_validate(params),
         {:ok, %{user: user, token: token}} <- Auth.create_user(validated_params) do
      conn
      |> put_status(:created)
      |> put_view(PeerLearningWeb.AuthJSON)
      |> render("auth.json", %{
        token: token,
        user: user
      })
    end
  end

  def create_intructor(conn, params) do
    with {:ok, validated_params} <- RegisterUser.cast_and_validate_instructor(params),
         {:ok, user} <- Auth.create_instructor(validated_params) do
      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end
  end

  def verify_user(conn, %{"email" => email, "token" => token}) do
    with {:ok, decoded_email} <- Base.url_decode64(email, padding: false),
         {:ok, decoded_token} <- Base.url_decode64(token, padding: false),
         {:ok, user} <- Auth.verify_user(decoded_token, decoded_email),
         {:ok, token, _claims} <-
           Guardian.encode_and_sign(user, token_type: "auth") do
      conn
      |> put_status(200)
      |> json(%{
        data: %{
          token: token
        },
        status: "success"
      })
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def forgot_password(conn, params) do
    with {:ok, validated_params} <- EmailValidator.cast_and_validate(params),
         {:ok, user_token} <- Auth.send_forgot_password_url(validated_params.email) do
      conn
      |> put_status(200)
      |> json(%{
        data:
          %{
            # token: user_token.token
          },
        status: "success"
      })
    end
  end

  def reset_password(conn, params) do
    %{"email" => email, "token" => token, "password" => password} = params

    with {:ok, decoded_email} <- Base.url_decode64(email, padding: false),
         {:ok, decoded_token} <- Base.url_decode64(token, padding: false),
         {:ok, user} <- Auth.reset_password(decoded_token, decoded_email, %{password: password}),
         {:ok, token, _claims} <-
           Guardian.encode_and_sign(user, token_type: "auth") do
      conn
      |> put_status(200)
      |> json(%{
        data: %{
          token: token
        },
        status: "success"
      })
    end
  end

  def reset_password(conn, _params) do
    conn
    |> put_status(422)
    |> json(%{
      message: "mmy?",
      status: "failed"
    })
  end
end
