defmodule PeerLearningWeb.CourseJSON do
  alias PeerLearning.Courses.Course

  @doc """
  Renders a list of courses.
  """
  def index(%{courses: courses}) do
    %{data: for(course <- courses, do: data(course))}
  end

  @doc """
  Renders a single courses.
  """
  def show(%{course: course}) do
    %{data: data(course)}
  end

  def data(%Course{} = course) do
    %{
      id: course.id,
      default_currency: course.default_currency,
      is_active: course.is_active,
      age_range: course.age_range,
      level: course.level,
      description: course.description,
      title: course.title,
      amount: Money.to_string(course.amount, separator: "", delimiter: "", symbol: false),
      pretty_amount: Money.to_string(course.amount),
      is_active: course.is_active,
      metadata: course.metadata,
      deleted_at: course.deleted_at,
      inserted_at: course.inserted_at,
      updated_at: course.updated_at
    }
  end
end
