defmodule PeerLearningWeb.Validators.UserCoursePagination do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :page, :integer
    field :limit, :integer
    field :is_active, :boolean
    field :from_date, :date
    field :to_date, :date

    field :user_id, Ecto.UUID
    field :children_id, Ecto.UUID
  end

  @required_fields [
    :page,
    :limit
  ]
  @cast_fields [:user_id, :children_id, :is_active, :from_date, :to_date] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end
end
