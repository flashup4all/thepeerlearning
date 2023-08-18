defmodule PeerLearningWeb.Validators.CreateWeeklySchedule do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset
  alias PeerLearningWeb.Validators.CreateDaySchedule
  @primary_key false
  embedded_schema do
    field :week, Ecto.Enum, values: [:one, :two, :three, :four]
    embeds_many(:schedules, CreateDaySchedule)
  end

  @required_fields [:week]
  @cast_fields [] ++ @required_fields
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @cast_fields)
    |> cast_embed(:schedules, required: true)
    |> validate_required(@required_fields)
  end
end
