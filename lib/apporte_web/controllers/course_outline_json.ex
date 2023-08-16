defmodule PeerLearningWeb.CourseOutlineJSON do
  alias PeerLearning.Courses.CourseOutline

  @doc """
  Renders a list of courses.
  """
  def index(%{course_outlines: course_outlines}) do
    %{
      data: for(course_outline <- course_outlines.entries, do: data(course_outline)),
      page_number: course_outlines.page_number,
      page_size: course_outlines.page_size,
      total_entries: course_outlines.total_entries,
      total_pages: course_outlines.total_pages
    }
  end

  @doc """
  Renders a single courses.
  """
  def show(%{course_outline: course_outline}) do
    %{data: data(course_outline)}
  end

  def data(%CourseOutline{} = course_outline) do
    %{
      id: course_outline.id,
      content: course_outline.content,
      description: course_outline.description,
      title: course_outline.title,
      deleted_at: course_outline.deleted_at,
      inserted_at: course_outline.inserted_at,
      updated_at: course_outline.updated_at
    }
  end
end
