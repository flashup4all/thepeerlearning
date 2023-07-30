defmodule PeerLearning.Accounts.UserProfile do
  @moduledoc false

  alias PeerLearning.Repo
  use PeerLearning.Schema

  import Ecto.Changeset

  alias PeerLearning.Accounts.User

  @type t :: %__MODULE__{}

  schema "user_profiles" do
    field :address, :string
    field :country, :string
    field :dob, :naive_datetime
    field :fullname, :string
    field :gender, Ecto.Enum, values: [:male, :female, :non_binary, :others, :prefer_not_to_say]
    field :state_province_of_origin, :string
    belongs_to(:user, PeerLearning.Accounts.User)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:fullname]
  @cast_fields [:user_id, :dob, :gender, :state_province_of_origin, :address, :country] ++
                 @required_fields
  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(%User{} = user, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
  end

  def create_user_profile(%User{} = user, params) do
    changeset(user, params)
    |> Repo.insert()
  end

  def get_user_profile_by_user_id(user_id) do
    case Repo.get_by(__MODULE__, user_id: user_id) do
      %__MODULE__{} = user_profile -> {:ok, user_profile}
      nil -> {:error, :not_found}
    end
  end

  def update(%__MODULE__{} = user_profile, update_params) do
    user_profile
    |> cast(update_params, @cast_fields)
    |> validate_required(@required_fields)
    |> Repo.update()
  end
end
