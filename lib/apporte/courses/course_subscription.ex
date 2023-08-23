defmodule PeerLearning.Courses.CourseSubscription do
  @moduledoc false

  alias PeerLearning.Repo
  alias PeerLearning.Courses.Course
  alias PeerLearning.Accounts.{User, Children}
  alias PeerLearning.Billing.Transaction

  use PeerLearning.Schema
  import Ecto.Query
  import PeerLearning.DynamicFilter

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "course_subscriptions" do
    field :timezone, :string
    field :is_active, :boolean, default: true
    field :is_expired, :boolean, default: false
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :description, :string
    field :feedback, :string
    field :rating, :integer

    belongs_to(:user, User)
    belongs_to(:course, Course)
    belongs_to(:transaction, Transaction)
    belongs_to(:children, PeerLearning.Accounts.Children)
    has_many(:user_course_outlines, PeerLearning.Courses.UserCourseOutline)

    timestamps()
  end

  def fields, do: __MODULE__.__schema__(:fields)

  @required_fields [
    :timezone,
    :start_date,
    :end_date
  ]
  @cast_fields [:is_active, :is_expired, :description, :feedback, :rating] ++
                 @required_fields

  @doc false
  def changeset(
        %User{} = user,
        %Children{} = child,
        %Course{} = course,
        %Transaction{} = transaction,
        params
      ) do
    %__MODULE__{}
    |> cast(params, @cast_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:user, user)
    |> put_assoc(:course, course)
    |> put_assoc(:transaction, transaction)
    |> put_assoc(:children, child)
  end

  def create(
        %User{} = user,
        %Children{} = child,
        %Course{} = course,
        %Transaction{} = transaction,
        params
      ) do
    {:ok, start_date} = DateTime.new(Date.from_iso8601!(params.start_date), Time.utc_now())
    end_date = start_date |> DateTime.add(31, :day)

    params = Map.put(params, :start_date, start_date) |> Map.put(:end_date, end_date)

    changeset(user, child, course, transaction, params)
    |> Repo.insert()
  end

  def list(params) do
    query =
      __MODULE__
      |> filter(:children_id, :eq, params.children_id)
      |> filter(:user_id, :eq, params.user_id)
      |> filter(:is_active, :eq, params.is_active)
      |> filter(:range, :date, params.from_date, params.to_date)
      |> v1_preload()

    # |> where([course], course.is_active == true)

    Repo.paginate(query, page: params.page, page_size: params.limit)
  end

  def v1_preload(query) do
    query
    |> preload([course_subscription], [:user_course_outlines])
  end

  def preload(course_subscription) do
    Repo.preload(course_subscription, [:user_course_outlines])
  end

  def get_course_subscription(user_id, course_subscription_id) do
    query =
      __MODULE__
      |> where([course_subscription], course_subscription.id == ^course_subscription_id)
      |> where([course_subscription], course_subscription.user_id == ^user_id)
      |> v1_preload()

    case Repo.one(query) do
      nil ->
        {:error, :not_found}

      course ->
        {:ok, course}
    end
  end

  def get_user_active_course_subscription(user_id) do
    query =
      __MODULE__
      |> where([course_subscription], course_subscription.user_id == ^user_id and course_subscription.is_active == true)
      |> v1_preload()

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
