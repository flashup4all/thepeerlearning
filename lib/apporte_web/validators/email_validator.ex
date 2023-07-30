defmodule PeerLearningWeb.Validators.EmailValidator do
  @moduledoc """
    ForgotPassword Validator
  """
  use PeerLearning.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :email, :string
  end

  @required_fields [:email]
  @cast_fields @required_fields
  @doc false
  def cast_and_validate(attrs) do
    %__MODULE__{}
    |> cast(attrs, @cast_fields)
    |> validate_required(@required_fields)
    |> update_change(:email, &String.downcase(&1 || ""))
    |> validate_format(
      :email,
      ~r/^[\w.!#$%&'*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i
    )
    |> apply_changes_if_valid()
  end

  # defp validate_password(changeset) do
  #   changeset
  #   |> validate_required([:password])
  #   |> validate_length(:password, min: 6, max: 72)
  #   |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
  #   |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
  #   |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/,
  #     message: "at least one digit or punctuation character"
  #   )
  # end
end
