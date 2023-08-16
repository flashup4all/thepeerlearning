defmodule PeerLearning.Courses do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo

  alias PeerLearning.Accounts.{User, UserProfile, Children}
  alias PeerLearning.Courses.{ClassScheduleDraft, Course, CourseOutline}
  alias PeerLearning.Integrations.Stripe
  alias PeerLearning.Integrations.Stripe.PaymentIntent

  alias PeerLearningWeb.Validators.{
    UserClassSchedule,
    CourseValidator,
    CourseOutlineValidator,
    Pagination
  }

  def create_schedule_draft(%User{} = user, %UserClassSchedule{} = params) do
    params = %{params | schedules: Enum.map(params.schedules, &Map.from_struct(&1))}

    with {:ok, encoded_draft} <- Jason.encode(Map.from_struct(params)),
         {:error, _} <- ClassScheduleDraft.get_user_draft(user.id),
         {:ok, %ClassScheduleDraft{} = draft} <-
           ClassScheduleDraft.create(user, %{content: encoded_draft}) do
      {:ok, draft}
    else
      {:ok, %ClassScheduleDraft{} = draft} ->
        {:ok, encoded_draft} = Jason.encode(Map.from_struct(params))
        ClassScheduleDraft.update(draft, %{content: encoded_draft})

      {:error, error} ->
        {:error, :custom, :bad_request, "Error", "error"}

      error ->
        {:error, :custom, :bad_request, "Error", error}
    end
  end

  def create_course(%CourseValidator{} = params) do
    with {:ok, %Course{} = course} <- Course.create(Map.from_struct(params)) do
      {:ok, course}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def update_course(course_id, %CourseValidator{} = params) do
    with {:ok, %Course{} = course} <- Course.get_course(course_id),
         {:ok, %Course{} = course} <- Course.update(course, Map.from_struct(params)) do
      {:ok, course}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def get_course(course_id) do
    with {:ok, %Course{} = course} <- Course.get_course(course_id) do
      {:ok, course}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def list_courses() do
    Course.list()
  end

  def delete_course(course_id) do
    with {:ok, %Course{} = course} <- Course.get_course(course_id),
         {:ok, %Course{} = course} <- Course.update(course, %{deleted_at: DateTime.utc_now()}) do
      {:ok, course}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def create_course_outline(course_id, %CourseOutlineValidator{} = params) do
    with {:ok, %Course{} = course} <- Course.get_course(course_id),
         {:ok, %CourseOutline{} = course_outline} <-
           CourseOutline.create(course, Map.from_struct(params)) do
      {:ok, course_outline}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def update_course_outline(course_outline_id, %CourseOutlineValidator{} = params) do
    with {:ok, %CourseOutline{} = course_outline} <-
           CourseOutline.get_course_outline(course_outline_id),
         {:ok, %CourseOutline{} = course_outline} <-
           CourseOutline.update(course_outline, Map.from_struct(params)) do
      {:ok, course_outline}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def get_course_outline(course_outline_id) do
    with {:ok, %CourseOutline{} = course_outline} <-
           CourseOutline.get_course_outline(course_outline_id) do
      {:ok, course_outline}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def list_course_outlines(%Pagination{} = params) do
    CourseOutline.list(params)
  end

  def delete_course_outline(course_id) do
    with {:ok, %CourseOutline{} = course_outline} <- CourseOutline.get_course_outline(course_id),
         {:ok, %CourseOutline{} = course_outline} <-
           CourseOutline.update(course_outline, %{deleted_at: DateTime.utc_now()}) do
      {:ok, course_outline}
    else
      {:error, error} ->
        {:error, error}

      error ->
        {:error, error}
    end
  end

  def create_payment_intent() do
    Stripe.create_payment_intent(%PaymentIntent{
      amount: 6000,
      currency: "USD",
      automatic_payment_methods: %{
        enabled: true,
      },
      customer: %{},
      metadata: %{
        email: "email@mail.com",
        id: 2
      }
    })

    # Stripe.PaymentIntent.create(%{
    #   amount: 6000,
    #   currency: "USD",
    #   automatic_payment_methods: %{
    #       enabled: true,
    #     },
    #     customer: %{},
    #     metadata: %{
    #       email: "email@mail.com",
    #       id: 2
    #     }
    # })
  end
end
