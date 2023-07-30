defmodule PeerLearningWeb.Validators.FilterChildren do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :page, :integer
    field :user_id, Ecto.UUID
    field :page_size, :integer, default: 15
    field :order, Ecto.Enum, values: [:asc, :desc]
  end

  @required_fields [:page]
  @cast_fields [:page_size, :order, :user_id] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
