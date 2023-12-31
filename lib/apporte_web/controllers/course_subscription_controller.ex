defmodule PeerLearningWeb.CourseSubscriptionController do
  use PeerLearningWeb, :controller

  alias PeerLearning.{Courses}
  alias PeerLearningWeb.Validators.{UserCoursePagination}

  action_fallback PeerLearningWeb.FallbackController

  def index(conn, params) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- UserCoursePagination.cast_and_validate(params),
         course_subscriptions <- Courses.list_user_course_subscriptions(user, validated_params) do
      conn
      |> put_status(200)
      |> render(:index_pagination, course_subscriptions: course_subscriptions)
    end
  end

  def show_active_course(conn, _params) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, course_subscription} = course_subscriptions <-
           Courses.list_user_active_course_subscription(user) do
      conn
      |> put_status(200)
      |> render(:show, course_subscription: course_subscription)
    end
  end

  def show(conn, %{"course_subscription_id" => course_subscription_id}) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, course_subscription} <-
           Courses.list_user_course_subscription(user, course_subscription_id) do
      conn
      |> put_status(200)
      |> render(:show, course_subscription: course_subscription)
    end
  end

  def process_user_courses(conn, %{"user_id" => user_id, "transaction_id" => transaction_id}) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    # with {:ok, course_subscription} <-
    # do
    Courses.process_user_courses(user_id, transaction_id)

    conn
    |> put_status(:created)
    |> json(%{
      # data: Jason.decode!(class_schedule_draft.content),
      status: "success"
    })

    #   conn
    #   |> put_status(200)
    #   |> render(:show, course_subscription: course_subscription)
    # end
  end
end
