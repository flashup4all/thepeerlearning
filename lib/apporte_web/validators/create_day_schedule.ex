defmodule PeerLearningWeb.Validators.CreateDaySchedule do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :day, :string
    field :time, :string
  end

  @required_fields [:day, :time]
  @cast_fields [] ++ @required_fields
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
