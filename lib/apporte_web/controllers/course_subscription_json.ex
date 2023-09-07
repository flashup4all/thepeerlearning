defmodule PeerLearningWeb.CourseSubscriptionJSON do
  alias PeerLearning.Courses.CourseSubscription
  alias PeerLearningWeb.UserCourseOutlineJSON
  alias PeerLearningWeb.CourseJSON
  alias PeerLearningWeb.ChildrenJSON
  alias PeerLearningWeb.UserJSON

  @doc """
  Renders a list of courses.
  """
  def index_pagination(%{course_subscriptions: course_subscriptions}) do
    %{
      data:
        for(course_subscription <- course_subscriptions.entries, do: data(course_subscription)),
      page_number: course_subscriptions.page_number,
      page_size: course_subscriptions.page_size,
      total_entries: course_subscriptions.total_entries,
      total_pages: course_subscriptions.total_pages
    }
  end

  def index(%{course_subscriptions: course_subscriptions}) do
    %{
      data: for(course_subscription <- course_subscriptions, do: data(course_subscription))
    }
  end

  @doc """
  Renders a single courses.
  """
  def show(%{course_subscription: course_subscription}) do
    %{data: data(course_subscription)}
  end

  def data(%CourseSubscription{} = course_subscription) do
    %{
      id: course_subscription.id,
      timezone: course_subscription.timezone,
      is_active: course_subscription.is_active,
      is_expired: course_subscription.is_expired,
      start_date: course_subscription.start_date,
      end_date: course_subscription.end_date,
      description: course_subscription.description,
      feedback: course_subscription.feedback,
      rating: course_subscription.rating,
      user_id: course_subscription.user_id,
      course_id: course_subscription.course_id,
      transaction_id: course_subscription.transaction_id,
      instructor_id: course_subscription.instructor_id,
      children_id: course_subscription.children_id,
      inserted_at: course_subscription.inserted_at,
      updated_at: course_subscription.updated_at,
      course: CourseJSON.data(course_subscription.course),
      chilren: ChildrenJSON.data(course_subscription.children),
      instructor:
        if(Ecto.assoc_loaded?(course_subscription.instructor),
          do: UserJSON.data(course_subscription.instructor),
          else: nil
        ),
      user_course_outlines:
        UserCourseOutlineJSON.index_assoc(%{
          user_course_outlines: course_subscription.user_course_outlines
        })
    }
  end
end
