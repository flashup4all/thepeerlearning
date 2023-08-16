defmodule PeerLearningWeb.ChildrenController do
  use PeerLearningWeb, :controller

  alias PeerLearning.{Accounts}
  alias PeerLearning.Accounts.{Children}
  alias PeerLearningWeb.Validators.{FilterChildren, AddChild, UpdateChild}

  action_fallback PeerLearningWeb.FallbackController

  def index(conn, %{"user_id" => _user_id} = params) do
    # user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- FilterChildren.cast_and_validate(params),
         children <- Accounts.list_user_children(validated_params) do
      conn
      |> put_status(200)
      |> render(:index, children: children)
    end
  end

  def index(conn, params) do
    with {:ok, validated_params} <- FilterChildren.cast_and_validate(params),
         children <- Accounts.list_children(validated_params) do
      conn
      |> put_status(200)
      |> render(:index, children: children)
    end
  end

  def create(conn, params) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- AddChild.cast_and_validate(params),
         {:ok, %Children{} = child} <- Accounts.create_child(user, validated_params) do
      conn
      |> put_status(:created)
      |> render(:show, children: child)
    end
  end

  def update(conn, %{"id" => child_id} = params) do
    with {:ok, validated_params} <- UpdateChild.cast_and_validate(params),
         {:ok, %Children{} = child} <- Accounts.update_child(child_id, validated_params) do
      conn
      |> put_status(200)
      |> render(:show, children: child)
    end
  end

  def delete(conn, %{"id" => child_id}) do
    {:ok, %Children{} = child} = Accounts.delete_child(child_id)

    conn
    |> put_status(200)
    |> render(:show, children: child)
  end
end
