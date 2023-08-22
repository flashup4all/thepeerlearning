defmodule PeerLearning.Billing.Transaction do
  @moduledoc false

  alias PeerLearning.Repo
  use PeerLearning.Schema
  import Ecto.Query
  alias PeerLearning.Accounts.User
  alias PeerLearning.Billing.InitiateTransaction
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "transactions" do
    field :gateway_ref, :string
    field :type, Ecto.Enum, values: [:credit, :debit]
    field :provider, Ecto.Enum, values: [:stripe, :paystack], default: :stripe
    field :status, Ecto.Enum, values: [:success, :pending, :processing], default: :processing

    field :purpose, Ecto.Enum,
      values: [:course_subscription, :instructor_remitance],
      default: :course_subscription

    field :amount, Money.Ecto.Amount.Type
    field :currency, :string, default: "USD"

    field :fee, Money.Ecto.Amount.Type
    field :gateway_fee, Money.Ecto.Amount.Type
    field :metadata, :map
    field :gateway_context, :map
    belongs_to(:user, User)
    belongs_to(:initiate_transaction, InitiateTransaction)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [
    :purpose,
    :amount,
    :type
  ]
  @cast_fields [:metadata, :gateway_ref, :status, :provider, :fee, :gateway_fee] ++
                 @required_fields

  @doc false
  def changeset(%User{} = user, %InitiateTransaction{} = initiate_transaction, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    # |> update_change(:amount, &Money.multiply(Money.new(&1.amount), 100))
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
    |> put_assoc(:initiate_transaction, initiate_transaction)
  end

  def create(%User{} = user, %InitiateTransaction{} = initiate_transaction, params) do
    changeset(user, initiate_transaction, params)
    |> Repo.insert()
  end

  def get_transaction(transaction_id) do
    query =
      __MODULE__
      |> where([transaction], transaction.id == ^transaction_id)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      initiate_transaction ->
        {:ok, initiate_transaction}
    end
  end

  def get_transaction_with_gateway_ref(ref) do
    query =
      __MODULE__
      |> where([transaction], transaction.gateway_ref == ^ref)

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      initiate_transaction ->
        {:ok, initiate_transaction}
    end
  end
end
