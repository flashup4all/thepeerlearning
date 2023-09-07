defmodule PeerLearningWeb.Validators.CreateUser do
  @moduledoc """
    CreateUser Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset
  alias PeerLearningWeb.Validators.{CreateUserProfile, CreateUserChild}

  @primary_key false
  embedded_schema do
    field :email, :string
    field :password, :string
    field :user_type, Ecto.Enum, values: [:user, :business]
    field :role, Ecto.Enum, values: [:child, :admin, :super_admin, :instructor, :parent]
    field :phone_number, :string
  end

  @required_fields [:email, :password, :user_type, :phone_number]
  @cast_fields [:role] ++ @required_fields
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase(&1 || ""))
    |> validate_format(
      :email,
      ~r/^[\w.!#$%&'*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i
    )
    |> validate_password()
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 72)
    |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
      message: "at least one digit or punctuation character"
    )
  end
end
