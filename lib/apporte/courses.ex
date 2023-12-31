defmodule PeerLearning.Courses do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo
  alias PeerLearning.Integrations.Zoom

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
             ClassScheduleDraft.get_user_pending_draft(user_id),
           {:ok,
            %{
              "weeks" => weeks,
              "course_id" => course_id,
              "children_id" => children_id,
              "timezone" => timezone,
              "start_date" => start_date
            } = decoded_draft} <- Jason.decode(draft.content),
           {:ok, %User{} = user} <- User.get_user(user_id),
           {:ok, %User{} = user} <-
             User.update_user(user, %{registration_step: :completed}),
           {:ok, %User{} = instructor} <- User.default_instructor(),
           {:ok, %Course{} = course} <- Course.get_course(course_id),
           {:ok, %Children{} = child} <- Children.get_user_child(user.id, children_id),
           {:ok, %Transaction{} = transaction} <- Transaction.get_transaction(transaction_id),

           {:ok, %CourseSubscription{} = course_subscription} <-
             CourseSubscription.create(user, child, course, transaction, instructor, %{
               timezone: timezone,
               start_date: start_date
             }),
           [%CourseOutline{} | _] = course_outlines <-
             CourseOutline.course_outlines(course_subscription.course_id),
            {:ok, start_date} <-Date.from_iso8601(start_date),
           :ok <-
             schedule_manager(
               weeks,
               Enum.chunk_every(course_outlines, 2),
               start_date,
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
         [chucked_outline | course_outlines],
         today,
         user,
         child,
         course,
         course_subscription
       ) do
    first_week["schedules"]
    |> Enum.with_index()
    |> Enum.each(fn {schedule, i} ->
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

      {:ok, outline} =
        UserCourseOutline.create(
          user,
          course_subscription,
          child,
          Enum.at(chucked_outline, i),
          params
        )

      # generate zoom url
      PeerLearningEvents.course_service_to_create_zoom_meeting_url_for_course_outline(%{
        "type" => "create_zoom_url_for_course_outline",
        "payload" => %{
          "user_email" => user.email,
          "user_course_outline_id" => outline.id,
          "course_outline_title" => Enum.at(chucked_outline, i).title,
          "course_outline_description" => Enum.at(chucked_outline, i).description
        }
      })
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

  defp schedule_manager(shedules, _, _, user, _child, _course, course_subscription) when shedules == [] do
    with {:ok, %UserCourseOutline{} = next_class} <- UserCourseOutline.get_next_class(course_subscription.id),
    {:ok, %UserCourseOutline{} = last_class} <- UserCourseOutline.get_last_class(course_subscription.id) do
      course_subscription = course_subscription |> Map.put(:next_class, next_class) |> Map.put(:last_class, last_class)

      {:ok, profile} = UserProfile.get_user_profile_by_user_id(user.id)
      PeerLearningEvents.email_service_deliver_welcome_mail(%{
        "type" => "deliver_welcome_mail",
        "payload" => %{
          "email" => user.email,
          "first_name" => profile.fullname,
          "start_date" => Calendar.strftime(next_class.date, "%b %d, %Y"),
          "start_time" => next_class.time
        }
      })
      :ok
    end
        # send welcom mail
        
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

  def process_user_courses(user_id, transaction_id) do
    PeerLearningEvents.course_service_to_create_user_courses(%{
      "type" => "create_user_courses",
      "payload" => %{
        "user_id" => user_id,
        "transaction_id" => transaction_id
      }
    })
  end

  def create_zoom_url_for_course_outline(payload) do
    with {:ok, %UserCourseOutline{} = user_course_outline} <-
           UserCourseOutline.get(payload["user_course_outline_id"]),
         {:ok, zoom_auth_response} <- Zoom.create_oauth_token(),
         {:ok, zoom_response} <-
           Zoom.create_meeting(
             %{
               agenda: payload["course_outline_description"],
               type: 1,
               settings: %{
                 allow_multiple_devices: true
               },
               meeting_invitees: [
                 %{
                   email: payload["user_email"]
                 }
               ],
               email_notification: true,
               start_time: user_course_outline.date,
               timezone: "America/Los_Angeles",
               topic: payload["course_outline_title"]
             },
             zoom_auth_response["access_token"]
           ),
         {:ok, %UserCourseOutline{} = user_course_outline} <-
           UserCourseOutline.update(user_course_outline, %{
             meeting_url: zoom_response["start_url"]
           }) do
      {:ok, user_course_outline}
    end
  end

  def list_user_course_subscriptions(%User{} = user, %UserCoursePagination{} = params) do
    CourseSubscription.list(params |> Map.put(:user_id, user.id))
  end

  def list_user_course_subscription(%User{} = user, course_subscription_id) do
    CourseSubscription.get_course_subscription(user.id, course_subscription_id)
  end

  def list_user_active_course_subscription(%User{} = user) do
    with {:ok, %CourseSubscription{} = course_subscription} <- CourseSubscription.get_user_active_course_subscription(user.id),
    {:ok, %UserCourseOutline{} = next_class} <- UserCourseOutline.get_next_class(course_subscription.id),
    {:ok, %UserCourseOutline{} = last_class} <- UserCourseOutline.get_last_class(course_subscription.id) do
      course_subscription = course_subscription |> Map.put(:next_class, next_class) |> Map.put(:last_class, last_class)
      {:ok, course_subscription}
    end
  end

  def list_user_course_outlines(%User{} = user, params) do
    UserCourseOutline.list(params |> Map.put(:user_id, user.id))
  end

  def list_user_course_outlines(params) do
    UserCourseOutline.list(params)
  end

  def list_user_course_outline(user, course_subscription_id, user_course_outline_id) do
    with {:ok, %CourseSubscription{} = course_subscription} <-
           CourseSubscription.get_course_subscription(user.id, course_subscription_id),
         {:ok, %UserCourseOutline{} = user_course_outline} <-
           UserCourseOutline.get(user_course_outline_id) do
      {:ok, user_course_outline}
    end
  end

  def update_instructor_user_course_outline_status(user_course_outline_id, params) do
    params = Map.put(params, :status, params.instructor_status)
    with {:ok, %UserCourseOutline{} = user_course_outline} <-
           UserCourseOutline.get(user_course_outline_id),
         {:ok, %UserCourseOutline{} = user_course_outline} <-
           UserCourseOutline.update(user_course_outline, Map.from_struct(params)) do
      {:ok, user_course_outline}
    end
  end
end
