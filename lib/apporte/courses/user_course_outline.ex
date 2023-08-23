defmodule PeerLearning.Courses.UserCourseOutline do
  @moduledoc false

  alias PeerLearning.Repo
  alias PeerLearning.Courses.Course
  alias PeerLearning.Accounts.{User, Children}
  alias PeerLearning.Courses.{CourseOutline, CourseSubscription}
  use PeerLearning.Schema
  import Ecto.Query
  import PeerLearning.DynamicFilter

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "user_course_outlines" do
    field :meeting_url, :string
    field :notes, :string
    field :assignment, :string
    field :child_feedback, :string
    field :instructor_feedback, :string
    field :metadata, :map
    field :date, :utc_datetime
    field :time, :string
    field :status, Ecto.Enum, values: [:completed, :pending, :ongoing], default: :pending
    field :instructor_status, Ecto.Enum, values: [:completed, :pending, :ongoing]
    field :child_status, Ecto.Enum, values: [:completed, :pending, :ongoing]

    belongs_to(:user, User)
    belongs_to(:instructor, User)
    belongs_to(:children, Children)
    belongs_to(:course_outline, CourseOutline)
    belongs_to(:course_subscription, CourseSubscription)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [:date, :time]
  @cast_fields [
                 :meeting_url,
                 :notes,
                 :assignment,
                 :child_feedback,
                 :instructor_feedback,
                 :metadata,
                 :status,
                 :instructor_status,
                 :child_status
               ] ++
                 @required_fields

  @doc false
  def changeset(
        %User{} = user,
        %CourseSubscription{} = course_subscription,
        %Children{} = children,
        %CourseOutline{} = course_outline,
        params
      ) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
    |> put_assoc(:course_outline, course_outline)
    |> put_assoc(:course_subscription, course_subscription)
    |> put_assoc(:children, children)
  end

  def create(
        %User{} = user,
        %CourseSubscription{} = course_subscription,
        %Children{} = children,
        %CourseOutline{} = course_outline,
        params
      ) do
    changeset(user, course_subscription, children, course_outline, params)
    |> Repo.insert()
  end

  def preload(query) do
    query
    |> preload([course_subscription], [:course_outline, :instructor])
  end

  def list(params) do
    query =
      __MODULE__
      |> filter(:children_id, :eq, params.children_id)
      |> filter(:user_id, :eq, params.user_id)
      |> filter(:course_subscription_id, :eq, params.course_subscription_id)
      |> filter(:user_id, :eq, params.user_id)
      |> filter(:range, :date, params.from_date, params.to_date)
      |> preload()

    Repo.paginate(query, page: params.page, page_size: params.limit)
  end

  def get(user_course_outline_id) do
    query =
      __MODULE__
      |> where([user_course_outline], user_course_outline.id == ^user_course_outline_id)
      |> preload()

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      user_course_outline ->
        {:ok, user_course_outline}
    end
  end

  def update(%__MODULE__{} = user_course_outline, update_params) do
    user_course_outline
    |> cast(update_params, @cast_fields -- [:unique_name])
    |> validate_required(@required_fields)
    |> unique_constraint(:unique_name, message: "unique_name has already been added.")
    |> Repo.update()
  end
end
