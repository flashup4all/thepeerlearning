defmodule PeerLearningWeb.Validators.UserCourseOutline do
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

    field :course_subscription_id, Ecto.UUID
    field :user_id, Ecto.UUID
    field :children_id, Ecto.UUID
    field :instructor_feedback, :string
    field :status, Ecto.Enum, values: [:completed, :pending, :ongoing, :missed], default: :pending
    field :instructor_status, Ecto.Enum, values: [:completed, :pending, :ongoing, :missed]
    field :notes, :string
    field :assignment, :string
    field :child_feedback, :string
  end

  @required_fields [
    :page,
    :limit
  ]
  @cast_fields [
                 :user_id,
                 :children_id,
                 :is_active,
                 :from_date,
                 :to_date,
                 :course_subscription_id,
                 :instructor_feedback,
                 :status,
                 :instructor_status,
                 :notes,
                 :assignment,
                 :child_feedback
               ] ++
                 @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end

  def instructor_complete_class_session_cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:instructor_feedback, :instructor_status])
    |> validate_required([:instructor_status])
    |> apply_changes_if_valid()
  end
end
