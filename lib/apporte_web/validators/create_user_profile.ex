defmodule PeerLearningWeb.Validators.CreateUserProfile do
  @moduledoc """
    CreateUserProfile Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :fullname, :string
    field :dob, :naive_datetime
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
    field :state_province_of_origin, :string
    field :address, :string
    field :country, :string
  end

  @required_fields [:fullname, :country]
  @cast_fields [:dob, :gender, :state_province_of_origin, :address] ++ @required_fields
  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
  end
end
