defmodule PeerLearning.Courses.Course do
  @moduledoc false

  alias PeerLearning.Repo
  use PeerLearning.Schema
  import Ecto.Query

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "courses" do
    field :title, :string
    field :description, :string
    field :level, :string
    field :unique_name, :string
    field :amount, Money.Ecto.Amount.Type
    field :default_currency, :string
    field :age_range, :string
    field :is_active, :boolean, default: true

    field :metadata, :map
    field :deleted_at, :utc_datetime
    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [
    :title,
    :description,
    :amount,
    :default_currency,
    :age_range,
    :level,
    :unique_name
  ]
  @cast_fields [:metadata, :is_active, :deleted_at] ++
                 @required_fields

  @doc false
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> update_change(:amount, &Money.multiply(Money.new(&1.amount), 100))
    |> validate_required(@required_fields)
    |> unique_constraint(:unique_name, message: "unique_name has already been added.")
  end

  def create(params) do
    changeset(params)
    |> Repo.insert()
  end

  def list() do
    query =
      __MODULE__
      |> where([course], course.is_active == true)
      |> where([course], is_nil(course.deleted_at))

    Repo.all(query)
  end

  def get_course(course_id) do
    query =
      __MODULE__
      |> where([course], course.id == ^course_id)
      |> where([course], is_nil(course.deleted_at))

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      course ->
        {:ok, course}
    end
  end

  def update(%__MODULE__{} = course, update_params) do
    course
    |> cast(update_params, @cast_fields -- [:unique_name])
    |> validate_required(@required_fields)
    |> unique_constraint(:unique_name, message: "unique_name has already been added.")
    |> Repo.update()
  end
end
