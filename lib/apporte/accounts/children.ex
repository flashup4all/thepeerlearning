defmodule PeerLearning.Accounts.Children do
  @moduledoc false

  alias PeerLearning.Repo
  use PeerLearning.Schema
  import Ecto.Query

  import Ecto.Changeset

  alias PeerLearning.Accounts.User

  @type t :: %__MODULE__{}

  schema "children" do
    field :username, :string
    field :is_active, :boolean, default: true
    field :date_of_birth, :naive_datetime
    field :fullname, :string
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
    field :password_hash, :string
    belongs_to(:user, PeerLearning.Accounts.User)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:fullname]
  @cast_fields [:user_id, :password_hash, :gender, :is_active, :date_of_birth, :fullname] ++
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

  def create_child(%User{} = user, params) do
    changeset(user, params)
    |> Repo.insert()
  end

  def delete(%__MODULE__{} = children) do
    children
    |> Repo.delete()
  end

  def get_user_children(%{user_id: user_id} = params) do
    __MODULE__
    |> where([children], children.user_id == ^user_id)
    |> Repo.paginate(page: params.page, page_size: params.page_size)
  end

  def get_children(params) do
    __MODULE__ |> Repo.paginate(page: params.page, page_size: params.page_size)
  end

  def get_child(child_id) do
    query = __MODULE__ |> where([child], child.id == ^child_id)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      child ->
        {:ok, child}
    end
  end

  def get_user_child(user_id) do
    query = __MODULE__ |> where([child], child.user_id == ^user_id)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      child ->
        {:ok, child}
    end
  end

  def get_user_child(user_id, child_id) do
    query = __MODULE__ |> where([child], child.id == ^child_id and child.user_id == ^user_id)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      child ->
        {:ok, child}
    end
  end

  @spec update(
          PeerLearning.Accounts.Children.t(),
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  def update(%__MODULE__{} = children, update_params) do
    children
    |> cast(update_params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end
end
