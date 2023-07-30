defmodule PeerLearningWeb.Validators.UpdateChild do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :username, :string
    field :is_active, :boolean, default: true
    field :date_of_birth, :naive_datetime
    field :fullname, :string
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
    field :password_hash, :string
  end

  @required_fields []
  @cast_fields [:fullname, :gender, :username, :is_active, :date_of_birth] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
