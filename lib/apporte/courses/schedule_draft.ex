defmodule PeerLearning.Courses.ClassScheduleDraft do
  @moduledoc false

  alias PeerLearning.Repo
  use PeerLearning.Schema
  import Ecto.Query

  import Ecto.Changeset

  alias PeerLearning.Accounts.User

  @type t :: %__MODULE__{}

  schema "schedule_drafts" do
    field :content, :string
    belongs_to(:user, PeerLearning.Accounts.User)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:content]
  @cast_fields [:user_id] ++
                 @required_fields
  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(%User{} = user, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
  end

  def create(%User{} = user, params) do
    changeset(user, params)
    |> Repo.insert()
  end

  def delete(%__MODULE__{} = schedule_draft) do
    schedule_draft
    |> Repo.delete()
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
