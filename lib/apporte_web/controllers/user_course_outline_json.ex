defmodule PeerLearningWeb.UserCourseOutlineJSON do
  alias PeerLearning.Courses.UserCourseOutline
  alias PeerLearningWeb.CourseOutlineJSON

  @doc """
  Renders a list of courses.
  """
  def index(%{user_course_outlines: user_course_outlines}) do
    %{
      data: for(user_course_outline <- user_course_outlines, do: data(user_course_outline))
    }
  end

  def index_pagination(%{user_course_outlines: user_course_outlines}) do
    %{
      data:
        for(user_course_outline <- user_course_outlines.entries, do: data(user_course_outline)),
      page_number: user_course_outlines.page_number,
      page_size: user_course_outlines.page_size,
      total_entries: user_course_outlines.total_entries,
      total_pages: user_course_outlines.total_pages
    }
  end

  def index_assoc(%{user_course_outlines: user_course_outlines}) do
    for(user_course_outline <- user_course_outlines, do: data(user_course_outline))
  end

  @doc """
  Renders a single courses.
  """
  def show(%{user_course_outline: user_course_outline}) do
    %{data: data(user_course_outline)}
  end

  def data(%UserCourseOutline{} = user_course_outline) do
    %{
      id: user_course_outline.id,
      meeting_url: user_course_outline.meeting_url,
      notes: user_course_outline.notes,
      assignment: user_course_outline.assignment,
      child_feedback: user_course_outline.child_feedback,
      instructor_feedback: user_course_outline.instructor_feedback,
      metadata: user_course_outline.metadata,
      date: user_course_outline.date,
      time: user_course_outline.time,
      status: user_course_outline.status,
      instructor_status: user_course_outline.instructor_status,
      child_status: user_course_outline.child_status,
      user_id: user_course_outline.user_id,
      instructor_id: user_course_outline.instructor_id,
      children_id: user_course_outline.children_id,
      course_outline_id: user_course_outline.course_outline_id,
      course_subscription_id: user_course_outline.course_subscription_id,
      inserted_at: user_course_outline.inserted_at,
      updated_at: user_course_outline.updated_at,
      course_outline: CourseOutlineJSON.data(user_course_outline.course_outline)
    }
  end
end
