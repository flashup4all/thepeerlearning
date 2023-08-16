defmodule PeerLearningWeb.Validators.CourseOutlineValidator do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :title, :string
    field :description, :string
    field :content, :string
    field :is_active, :boolean
  end

  @required_fields [
    :title,
    :description
  ]
  @cast_fields [:content, :is_active] ++
                 @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> apply_changes_if_valid()
  end

  def update_cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields)
    |> validate_required([])
    |> apply_changes_if_valid()
  end
end
