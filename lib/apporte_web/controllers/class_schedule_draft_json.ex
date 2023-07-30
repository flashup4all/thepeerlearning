defmodule PeerLearningWeb.ClassScheduleDraftJSON do
  alias PeerLearning.Accounts.{User, Children}

  @doc """
  Renders a list of users.
  """
  def index(%{class_schedule_drafts: class_schedule_drafts}) do
    %{
      data: for(class_schedule_draft <- class_schedule_drafts.entries, do: data(class_schedule_draft)),
      page_number: class_schedule_drafts.page_number,
      page_size: class_schedule_drafts.page_size,
      total_entries: class_schedule_drafts.total_entries,
      total_pages: class_schedule_drafts.total_pages
    }
  end

  @doc """
  Renders a single user.
  """
  def show(%{class_schedule_draft: class_schedule_draft}) do
    %{data: data(class_schedule_draft)}
  end

  def data(%Children{} = class_schedule_draft) do
    %{
      id: class_schedule_draft.id,
      draft: class_schedule_draft.draft,
      inserted_at: class_schedule_draft.inserted_at,
      update_at: class_schedule_draft.update_at
    }
  end
end
