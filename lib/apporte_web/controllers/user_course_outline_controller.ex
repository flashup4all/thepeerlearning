defmodule PeerLearningWeb.UserCourseOutlineController do
  use PeerLearningWeb, :controller

  alias PeerLearning.{Courses}
  alias PeerLearningWeb.Validators.UserCourseOutline, as: UserCourseOutlineValidator

  action_fallback PeerLearningWeb.FallbackController

  def index(conn, %{"course_subscription_id" => _course_subscription_id} = params) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- UserCourseOutlineValidator.cast_and_validate(params),
         user_course_outlines <- Courses.list_user_course_outlines(user, validated_params) do
      conn
      |> put_status(200)
      |> render(:index_pagination, user_course_outlines: user_course_outlines)
    end
  end

  def index(conn, params) do
    # user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])
    with {:ok, validated_params} <- UserCourseOutlineValidator.cast_and_validate(params),
         user_course_outlines <- Courses.list_user_course_outlines(validated_params) do
      conn
      |> put_status(200)
      |> render(:index_pagination, user_course_outlines: user_course_outlines)
    end
  end

  def show(conn, %{
        "course_subscription_id" => course_subscription_id,
        "user_course_outline_id" => user_course_outline_id
      }) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, user_course_outline} <-
           Courses.list_user_course_outline(user, course_subscription_id, user_course_outline_id) do
      conn
      |> put_status(200)
      |> render(:show, user_course_outline: user_course_outline)
    end
  end

  def update_instructor_status(
        conn,
        %{
          "user_course_outline_id" => user_course_outline_id
        } = params
      ) do
    # user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <-
           UserCourseOutlineValidator.instructor_complete_class_session_cast_and_validate(params),
         {:ok, user_course_outline} <-
           Courses.update_instructor_user_course_outline_status(user_course_outline_id, validated_params) do
      conn
      |> put_status(200)
      |> render(:show, user_course_outline: user_course_outline)
    end
  end
end
