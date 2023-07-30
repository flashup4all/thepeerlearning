defmodule PeerLearningWeb.ChildrenJSON do
  alias PeerLearning.Accounts.{User, Children}

  @doc """
  Renders a list of users.
  """
  def index(%{children: children}) do
    %{
      data: for(child <- children.entries, do: data(child)),
      page_number: children.page_number,
      page_size: children.page_size,
      total_entries: children.total_entries,
      total_pages: children.total_pages
    }
  end

  @doc """
  Renders a single user.
  """
  def show(%{children: children}) do
    %{data: data(children)}
  end

  def data(%Children{} = children) do
    %{
      id: children.id,
      username: children.username,
      is_active: children.is_active,
      date_of_birth: children.date_of_birth,
      fullname: children.fullname,
      gender: children.gender,
      user_id: children.user_id
    }
  end
end
