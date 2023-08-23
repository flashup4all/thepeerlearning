defmodule PeerLearning.Courses do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo

  alias PeerLearning.Accounts.{User, UserProfile, Children}

  alias PeerLearning.Courses.{
    ClassScheduleDraft,
    Course,
    CourseOutline,
    CourseSubscription,
    UserCourseOutline
  }

  alias PeerLearning.Billing.Transaction

  alias PeerLearningWeb.Validators.{
    UserClassSchedule,
    CourseValidator,
    CourseOutlineValidator,
    Pagination,
    UserCoursePagination
  }

  def create_schedule_draft(
        %User{} = user,
        %UserClassSchedule{weeks: weeks, children_id: children_id, course_id: course_id} = params
      ) do
    weeks =
      Enum.map(weeks, fn week ->
        %{week | schedules: Enum.map(week.schedules, &Map.from_struct(&1))}
      end)

    params = %{params | weeks: Enum.map(weeks, &Map.from_struct(&1))}

    Repo.transaction(fn ->
      with {:ok, %Children{} = child} <- Children.get_user_child(user.id, children_id),
           {:ok, %Course{} = course} <- Course.get_course(course_id),
           {:ok, encoded_draft} <- Jason.encode(Map.from_struct(params)),
           {:error, _} <- ClassScheduleDraft.get_user_pending_draft(user.id, children_id),
           {:ok, %ClassScheduleDraft{} = draft} <-
             ClassScheduleDraft.create(user, child, %{content: encoded_draft}),
           {:ok, %User{} = user} <- User.update_user(user, %{registration_step: :class_schedule}) do
        draft
      else
        {:ok, %ClassScheduleDraft{} = draft} ->
          {:ok, encoded_draft} = Jason.encode(Map.from_struct(params))

          {:ok, %ClassScheduleDraft{} = draft} =
            ClassScheduleDraft.update(draft, %{content: encoded_draft})

          draft

        {:error, error} ->
          Repo.rollback(error)

        error ->
          Repo.rollback(error)
      end
    end)
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
    case CourseOutline.get_course_outline(course_outline_id) do
      {:ok, %CourseOutline{} = course_outline} -> {:ok, course_outline}
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  def list_course_outlines(course_id, %Pagination{} = params) do
    CourseOutline.list(course_id, params)
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

  def create_user_courses(user_id, transaction_id) do
    Repo.transaction(fn ->
      #  :ok <- insert_many_user_course_outline(user, children, course, course_subscription, weeks)
      with {:ok, %ClassScheduleDraft{} = draft} <-
             ClassScheduleDraft.get_user_draft(user_id),
           {:ok,
            %{
              "weeks" => weeks,
              "course_id" => course_id,
              "children_id" => children_id,
              "timezone" => timezone,
              "start_date" => start_date
            } = decoded_draft} <- Jason.decode(draft.content),
           {:ok, %User{} = user} <- User.get_user(user_id),
           {:ok, %Course{} = course} <- Course.get_course(course_id),
           {:ok, %Children{} = child} <- Children.get_user_child(user.id, children_id),
           {:ok, %Transaction{} = transaction} <- Transaction.get_transaction(transaction_id),
           {:ok, %CourseSubscription{} = course_subscription} <-
             CourseSubscription.create(user, child, course, transaction, %{
               timezone: timezone,
               start_date: start_date
             }),
           [%CourseOutline{} | _] = course_outlines <-
             CourseOutline.course_outlines(course_subscription.course_id),
           :ok <-
             schedule_manager(
               weeks,
               course_outlines,
               DateTime.utc_now(),
               user,
               child,
               course,
               course_subscription
             ),
           {:ok, %ClassScheduleDraft{} = draft} <-
             ClassScheduleDraft.update(draft, %{status: :completed}) do
        course_subscription
      else
        {:error, error} ->
          Repo.rollback(error)

        error ->
          Repo.rollback(error)
      end
    end)
  end

  defp schedule_manager(
         [first_week | schedules],
         course_outlines,
         today,
         user,
         child,
         course,
         course_subscription
       ) do
    first_week["schedules"]
    |> Enum.each(fn schedule ->
      end_of_week = Date.end_of_week(today)
      start_day = days_of_the_week(schedule["day"])
      class_schedule_date = end_of_week |> Date.add(start_day)
      {:ok, time} = Time.from_iso8601(schedule["time"] <> ":00")
      {:ok, start_date} = NaiveDateTime.new(class_schedule_date, time)

      # {:ok, start_date} = DateTime.new(Date.from_iso8601!(class_schedule_date), time) |> IO.inspect
      params = %{
        week: first_week["week"],
        date: start_date,
        time: Time.to_string(time)
      }

      UserCourseOutline.create(user, course_subscription, child, params)
    end)

    next_week = today |> Date.add(7)
    end_of_next_week = Date.end_of_week(next_week)

    schedule_manager(
      schedules,
      course_outlines,
      end_of_next_week,
      user,
      child,
      course,
      course_subscription
    )
  end

  defp schedule_manager(shedules, _, _, _user, _child, _course, _course_subscription)
       when shedules == [],
       do: :ok

  defp assign_course_outline_to_user(data, course_outlines) do
  end

  defp days_of_the_week(day) do
    case day do
      "monday" -> 1
      "tuesday" -> 2
      "wednesday" -> 3
      "thursday" -> 4
      "friday" -> 5
      "saturday" -> 6
      "sunday" -> 7
    end
  end

  def list_user_course_subscriptions(%User{} = user, %UserCoursePagination{} = params) do
    CourseSubscription.list(params |> Map.put(:user_id, user.id))
  end

  def list_user_course_subscription(%User{} = user, course_subscription_id) do
    CourseSubscription.get_course_subscription(user.id, course_subscription_id)
  end

  def list_user_active_course_subscription(%User{} = user) do
    CourseSubscription.get_user_active_course_subscription(user.id)
  end

  def list_user_course_outlines(%User{} = user, params) do
    UserCourseOutline.list(params |> Map.put(:user_id, user.id))
  end

  def list_user_course_outline(user, course_subscription_id, user_course_outline_id) do
    with {:ok, %CourseSubscription{} = course_subscription} <-
           CourseSubscription.get_course_subscription(user.id, course_subscription_id),
         {:ok, %UserCourseOutline{} = user_course_outline} <-
           UserCourseOutline.get(user_course_outline_id) do
      {:ok, user_course_outline}
    end
  end
end
