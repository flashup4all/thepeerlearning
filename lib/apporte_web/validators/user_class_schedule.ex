defmodule PeerLearningWeb.Validators.UserClassSchedule do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  alias PeerLearningWeb.Validators.CreateSchedule

  @primary_key false
  embedded_schema do
    field :timezone, :string
    field :course_id, Ecto.UUID
    field :start_date, :string
    field :other_options, :string
    embeds_many(:schedules, CreateSchedule)
  end

  @required_fields [:timezone, :start_date, :other_options, :course_id]
  @cast_fields [] ++ @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:schedules, required: true)
    |> apply_changes_if_valid()
  end
end
