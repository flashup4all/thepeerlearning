defmodule PeerLearningWeb.CourseController do
  use PeerLearningWeb, :controller

  alias PeerLearning.{Courses}
  alias PeerLearning.Courses.Course
  alias PeerLearningWeb.Validators.{CourseValidator}

  action_fallback PeerLearningWeb.FallbackController

  def index(conn, params) do
    courses = Courses.list_courses()

    conn
    |> put_status(200)
    |> render(:index, courses: courses)
  end

  def show(conn, %{"id" => course_id}) do
    with {:ok, %Course{} = course} <- Courses.get_course(course_id) do
      conn
      |> put_status(200)
      |> render(:show, course: course)
    end
  end

  def create(conn, params) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- CourseValidator.cast_and_validate(params),
         {:ok, %Course{} = course} <- Courses.create_course(validated_params) do
      conn
      |> put_status(:created)
      |> render(:show, course: course)
    end
  end

  def update(conn, %{"id" => course_id} = params) do
    with {:ok, validated_params} <- CourseValidator.update_cast_and_validate(params),
         {:ok, %Course{} = course} <- Courses.update_course(course_id, validated_params) do
      conn
      |> put_status(200)
      |> render(:show, course: course)
    end
  end

  def delete(conn, %{"id" => course_id}) do
    with {:ok, %Course{} = course} <- Courses.delete_course(course_id) do
      conn
      |> put_status(200)
      |> render(:show, course: course)
    end
  end
end
