defmodule PeerLearning.Courses.CourseOutline do
  @moduledoc false

  alias PeerLearning.Repo
  use PeerLearning.Schema
  import Ecto.Query

  import Ecto.Changeset
  alias PeerLearning.Courses.Course

  @type t :: %__MODULE__{}

  schema "course_outlines" do
    field :title, :string
    field :description, :string
    field :content, :string
    field :is_active, :boolean, default: true
    field :deleted_at, :utc_datetime

    belongs_to(:course, PeerLearning.Courses.Course)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [
    :title,
    :description
  ]
  @cast_fields [:is_active, :content, :deleted_at, :course_id] ++
                 @required_fields

  @doc false
  def changeset(%Course{} = course, params) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:course, course)
  end

  def create(%Course{} = course, params) do
    changeset(course, params)
    |> Repo.insert()
  end

  def list(params) do
    query =
      __MODULE__
      |> where([course_outline], course_outline.is_active == true)
      |> where([course_outline], is_nil(course_outline.deleted_at))
      |> Repo.paginate(page: params.page, page_size: params.limit)
  end

  def get_course_outline(course_id) do
    query =
      __MODULE__
      |> where([course_outline], course_outline.id == ^course_id)
      |> where([course_outline], is_nil(course_outline.deleted_at))

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      course_outline ->
        {:ok, course_outline}
    end
  end

  def update(%__MODULE__{} = course_outline, update_params) do
    course_outline
    |> cast(update_params, @cast_fields)
    |> validate_required([])
    |> unique_constraint(:unique_name, message: "unique_name has already been added.")
    |> Repo.update()
  end
end
