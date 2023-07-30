defmodule PeerLearning.ClassSchedules do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo

  alias PeerLearning.Accounts.{User, UserProfile, Children}
  alias PeerLearning.ClassSchedules.{ClassScheduleDraft}

  alias PeerLearningWeb.Validators.{UserClassSchedule}


  def create_schedule_draft(%User{} = user, %UserClassSchedule{} = params) do
    params  = %{params | schedules: Enum.map(params.schedules, &(Map.from_struct(&1)))}
    with {:ok, encoded_draft} <- Jason.encode(Map.from_struct(params)),
    {:error, _ } <- ClassScheduleDraft.get_user_draft(user.id),
    {:ok, %ClassScheduleDraft{} = draft} <- ClassScheduleDraft.create(user, %{content: encoded_draft}) do
        {:ok, draft}
    else
      {:ok, %ClassScheduleDraft{} = draft} ->
        {:ok, encoded_draft} = Jason.encode(Map.from_struct(params))
        ClassScheduleDraft.update(draft, %{content: encoded_draft})

      {:error, error} ->
      {:error, :custom, :bad_request, "Error", "error"}
      error ->
        {:error, :custom, :bad_request, "Error", error}
    end
  end
end
