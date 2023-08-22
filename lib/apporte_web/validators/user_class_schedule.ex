defmodule PeerLearningWeb.Validators.UserClassSchedule do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  alias PeerLearningWeb.Validators.CreateWeeklySchedule

  @primary_key false
  embedded_schema do
    field :timezone, :string
    field :course_id, Ecto.UUID
    field :children_id, Ecto.UUID
    field :start_date, :string
    field :other_options, :string
    embeds_many(:weeks, CreateWeeklySchedule)
  end

  @required_fields [:children_id, :timezone, :start_date, :course_id]
  @cast_fields [:other_options] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:weeks, required: true)
    |> apply_changes_if_valid()
  end
end
