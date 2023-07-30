defmodule PeerLearning.Accounts.UserToken do
  @moduledoc false
  use PeerLearning.Schema
  import Ecto.Query
  alias PeerLearning.Repo

  @hash_algorithm :sha256
  @rand_size 32

  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7

  @type t :: %__MODULE__{}

  schema "user_tokens" do
    field :token, :binary
    field :context, :string

    field :status, Ecto.Enum, values: [:inactive, :active], default: :active

    belongs_to(:user, PeerLearning.Accounts.User)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:token, :context, :user_id]
  @all_fields @required_fields ++ [:status]

  @spec changeset(map()) :: Ecto.Changeset.t()
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end

  def build_hashed_token() do
    token = :crypto.strong_rand_bytes(@rand_size)
    :crypto.hash(@hash_algorithm, token)
  end

  def create_user_token(%PeerLearning.Accounts.User{} = user, context) do
    hashed_token = build_hashed_token()

    params = %{token: hashed_token, context: context, user_id: user.id}

    params
    |> changeset()
    |> Repo.insert()
  end

  def list(user_id) do
    query =
      __MODULE__
      |> where([utk], utk.status == :active)
      |> where([utk], utk.user_id == ^user_id)
      |> select([utk], utk)

    Repo.all(query)
  end

  def deactivate_all(%PeerLearning.Accounts.User{} = user) do
    query =
      __MODULE__
      |> where([utk], utk.status == :active)
      |> where([utk], utk.user_id == ^user.id)
      |> select([utk], utk)

    Repo.update_all(query, set: [status: :inactive])
  end

  def update_status(%__MODULE__{} = user_token, status) do
    user_token
    |> change(status: status)
    |> Repo.update()
  end

  def verify_email_token(%PeerLearning.Accounts.User{} = user, token, context) do
    days = days_for_context(context)

    query =
      token_and_context_query(token, context)
      |> where([utk], utk.inserted_at > ago(^days, "day"))
      |> where([utk], utk.user_id == ^user.id)
      |> select([utk], utk)

    case Repo.one(query) do
      nil -> {:error, :not_found}
      user_token -> {:ok, user_token}
    end
  end

  defp token_and_context_query(token, context) do
    __MODULE__
    |> where([utk], utk.token == ^token)
    |> where([utk], utk.context == ^context)
    |> where([utk], utk.status == :active)
  end

  defp days_for_context("email"), do: @confirm_validity_in_days
  defp days_for_context("reset_password"), do: @reset_password_validity_in_days
  defp days_for_context("email_verification"), do: @confirm_validity_in_days
end
