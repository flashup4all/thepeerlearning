defmodule PeerLearning.Accounts.User do
  @moduledoc false

  use PeerLearning.Schema
  alias PeerLearning.Repo

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "users" do
    field :bvn, :string
    field :deleted_at, :naive_datetime
    field :email, :string
    field :is_active, :boolean, default: true
    field :is_bvn_verified, :boolean, default: false
    field :is_email_verified, :boolean, default: false
    field :is_phone_number_verified, :boolean, default: false
    field :metadata, :map
    field :password, :string, virtual: true
    field :password_hash, :binary
    field :phone_number, :string

    field :registration_step, Ecto.Enum,
      values: [:account_created, :class_schedule, :completed],
      default: :account_created

    field :role, Ecto.Enum, values: [:rider, :admin, :super_admin, :user, :branch_admin]
    field :user_type, Ecto.Enum, values: [:user, :business]

    has_one(:user_profile, PeerLearning.Accounts.UserProfile)
    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:email, :password, :user_type, :role, :phone_number]
  @cast_fields [
                 :is_active,
                 :is_bvn_verified,
                 :bvn,
                 :metadata,
                 :deleted_at,
                 :is_email_verified,
                 :is_phone_number_verified
               ] ++ @required_fields

  defp changeset(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase(&1 || ""))
    |> validate_format(
      :email,
      ~r/^[\w.!#$%&'*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i
    )
    |> validate_password(hash_password: true)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 72)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "at least one digit or punctuation character"
    )
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:password_hash, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  def create_user(params) do
    changeset(params)
    |> Repo.insert()
  end

  def update_user(%__MODULE__{} = user, params) do
    user
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields -- [:password])
    |> Repo.update()
  end

  def update_user_password(user, params) do
    user
    |> cast(params, [:password])
    |> validate_password(hash_password: true)
    |> Repo.update()
  end

  def verify_password(%__MODULE__{} = user, password) do
    Argon2.verify_pass(password, user.password_hash)
  end

  def get_user_by_email(email) do
    case Repo.get_by(__MODULE__, email: email) do
      %__MODULE__{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  end

  def get_user(id) do
    case Repo.get_by(__MODULE__, id: id) do
      %__MODULE__{} = user -> {:ok, user}
      nil -> {:error, :not_found}
    end
  end
end
