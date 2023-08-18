defmodule PeerLearning.Billing.InitiateTransaction do
  @moduledoc false

  alias PeerLearning.Repo
  use PeerLearning.Schema
  import Ecto.Query
  alias PeerLearning.Accounts.User
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "initiate_transactions" do
    field :gateway_ref, :string
    field :provider, Ecto.Enum, values: [:stripe, :paystack], default: :stripe
    field :status, Ecto.Enum, values: [:initiated, :completed], default: :initiated
    field :resource_id, :string
    field :resource_type, Ecto.Enum, values: [:course, :instructor], default: :course
    field :amount, Money.Ecto.Amount.Type
    field :metadata, :map
    field :deleted_at, :utc_datetime
    belongs_to(:user, User)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [
    :gateway_ref,
    :provider,
    :resource_id,
    :resource_type,
    :amount
  ]
  @cast_fields [:metadata, :deleted_at, :status] ++
                 @required_fields

  @doc false
  def changeset(%User{} = user, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    # |> update_change(:amount, &Money.multiply(Money.new(&1.amount), 100))
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
  end

  def create(%User{} = user, params) do
    changeset(user, params)
    |> Repo.insert()
  end

  def get_initiate_transaction(initiate_transaction_id) do
    query =
      __MODULE__
      |> where([transaction], transaction.id == ^initiate_transaction_id)
      |> where([transaction], is_nil(transaction.deleted_at))

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      initiate_transaction ->
        {:ok, initiate_transaction}
    end
  end
end
