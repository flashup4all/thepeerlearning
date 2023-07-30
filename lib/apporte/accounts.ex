defmodule PeerLearning.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo

  alias PeerLearning.Accounts.{User, UserProfile, Children}
  alias PeerLearningWeb.Validators.{FilterChildren, AddChild, UpdateChild}

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
