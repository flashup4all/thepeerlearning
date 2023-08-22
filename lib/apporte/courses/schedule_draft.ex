defmodule PeerLearning.Courses.ClassScheduleDraft do
  @moduledoc false

  alias PeerLearning.Repo
  use PeerLearning.Schema
  import Ecto.Query

  import Ecto.Changeset

  alias PeerLearning.Accounts.{User, Children}

  @type t :: %__MODULE__{}

  schema "schedule_drafts" do
    field :content, :string
    field :status, Ecto.Enum, values: [:completed, :pending, :ongoing], default: :pending
    belongs_to(:user, User)
    belongs_to(:children, Children)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:content]
  @cast_fields [:user_id, :status] ++
                 @required_fields
  @spec changeset(
          {map, map},
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(%User{} = user, %Children{} = children, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
    |> put_assoc(:children, children)
  end

  def create(%User{} = user, %Children{} = children, params) do
    changeset(user, children, params)
    |> Repo.insert()
  end

  def delete(%__MODULE__{} = schedule_draft) do
    schedule_draft
    |> Repo.delete()
  end

  def get_user_pending_draft(user_id, children_id) do
    query =
      __MODULE__
      |> where(
        [draft],
        draft.user_id == ^user_id and draft.children_id == ^children_id and
          draft.status == :pending
      )

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      draft ->
        {:ok, draft}
    end
  end

  def get_user_draft(user_id) do
    query = __MODULE__ |> where([children], children.user_id == ^user_id)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      draft ->
        {:ok, draft}
    end
  end

  def get_draft(draft_id) do
    query = __MODULE__ |> where([draft], draft.id == ^draft_id)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      draft ->
        {:ok, draft}
    end
  end

  def update(%__MODULE__{} = schedule_draft, update_params) do
    schedule_draft
    |> cast(update_params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end
end
