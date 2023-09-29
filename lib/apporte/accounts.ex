defmodule PeerLearning.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo

  alias PeerLearning.Accounts.{User, UserProfile, Children}
  alias PeerLearningWeb.Validators.{FilterChildren, AddChild, UpdateChild}

  def update_user_profile(user_id, params) do
    Repo.transaction(fn ->
      with {:ok, %User{} = user} <- User.get_user(user_id),
           {:ok, %UserProfile{} = user_profile} <-
             UserProfile.get_user_profile_by_user_id(user.id),
           {:ok, %UserProfile{} = user_profile} <- UserProfile.update(user_profile, params) do
        user_profile
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

  def get_user(id) do
    with {:ok, user} <- User.get_user(id) do
      {:ok, Repo.preload(user, [:children, :user_profile])}
    end
  end

  def list_children(%FilterChildren{page: _page, page_size: _page_size} = params) do
    Children.get_children(Map.from_struct(params))
  end

  def list_user_children(%FilterChildren{page: _page, page_size: _page_size} = params) do
    Children.get_user_children(Map.from_struct(params))
  end

  def create_child(%User{} = user, %AddChild{} = params) do
    Children.create_child(user, Map.from_struct(params))
  end

  def update_child(child_id, %UpdateChild{} = params) do
    with {:ok, %Children{} = child} <- Children.get_child(child_id),
         {:ok, %Children{} = child} <- Children.update(child, Map.from_struct(params)) do
      {:ok, child}
    end
  end

  def delete_child(child_id) do
    with {:ok, %Children{} = child} <- Children.get_child(child_id),
         {:ok, %Children{} = child} <- Children.delete(child) do
      {:ok, child}
    end
  end
end
