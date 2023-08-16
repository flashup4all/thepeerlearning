defmodule PeerLearningWeb.Validators.CourseValidator do
  @moduledoc """
    ResetPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :title, :string
    field :description, :string
    field :amount, Money.Ecto.Amount.Type
    field :default_currency, :string
    field :age_range, :string
    field :level, :string
    field :unique_name, :string
  end

  @required_fields [
    :title,
    :description,
    :amount,
    :default_currency,
    :age_range,
    :level,
    :unique_name
  ]
  @cast_fields [] ++
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
