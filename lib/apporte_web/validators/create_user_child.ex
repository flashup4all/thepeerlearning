defmodule PeerLearningWeb.Validators.CreateUserChild do
  @moduledoc """
    CreateUserProfile Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :fullname, :string
  end

  @required_fields [:fullname]
  @cast_fields @required_fields
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
