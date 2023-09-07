defmodule PeerLearningWeb.Validators.RegisterUser do
  @moduledoc """
    CreateUser Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset
  alias PeerLearningWeb.Validators.{CreateUserProfile, CreateUserChild, CreateUser}

  @primary_key false
  embedded_schema do
    embeds_one(:parent, CreateUserProfile)
    embeds_one(:child, CreateUserChild)
    embeds_one(:user, CreateUser)
    embeds_one(:instructor, CreateUserProfile)
  end

  @required_fields []
  @cast_fields @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> cast_embed(:user, required: true)
    |> cast_embed(:parent, required: true)
    |> cast_embed(:child, required: true)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end

  def cast_and_validate_instructor(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> cast_embed(:user, required: true)
    |> cast_embed(:instructor, required: true)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
