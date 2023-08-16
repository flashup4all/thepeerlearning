defmodule PeerLearningWeb.CourseOutlineController do
  use PeerLearningWeb, :controller

  alias PeerLearning.{Courses}
  alias PeerLearning.Courses.CourseOutline
  alias PeerLearningWeb.Validators.{CourseOutlineValidator, Pagination}

  action_fallback PeerLearningWeb.FallbackController

  def index(conn, params) do
    with {:ok, validated_params} <- Pagination.cast_and_validate(params),
         course_outlines <- Courses.list_course_outlines(validated_params) do
      conn
      |> put_status(200)
      |> render(:index, course_outlines: course_outlines)
    end
  end

  def show(conn, %{"id" => course_outline_id}) do
    with {:ok, %CourseOutline{} = course_outline} <- Courses.get_course_outline(course_outline_id) do
      conn
      |> put_status(200)
      |> render(:show, course_outline: course_outline)
    end
  end

  def create(conn, %{"course_id" => course_id} = params) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- CourseOutlineValidator.cast_and_validate(params),
         {:ok, %CourseOutline{} = course_outline} <-
           Courses.create_course_outline(course_id, validated_params) do
      conn
      |> put_status(:created)
      |> render(:show, course_outline: course_outline)
    end
  end

  def update(conn, %{"id" => course_id} = params) do
    with {:ok, validated_params} <- CourseOutlineValidator.update_cast_and_validate(params),
         {:ok, %CourseOutline{} = course_outline} <-
           Courses.update_course_outline(course_id, validated_params) do
      conn
      |> put_status(200)
      |> render(:show, course_outline: course_outline)
    end
  end

  def delete(conn, %{"id" => course_outline_id}) do
    with {:ok, %CourseOutline{} = course_outline} <-
           Courses.delete_course_outline(course_outline_id) do
      conn
      |> put_status(200)
      |> render(:show, course_outline: course_outline)
    end
  end
end
