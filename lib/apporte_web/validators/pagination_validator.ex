defmodule PeerLearningWeb.Validators.Pagination do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :page, :integer
    field :limit, :integer
  end

  @required_fields [
    :page
  ]
  @cast_fields [:limit] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
