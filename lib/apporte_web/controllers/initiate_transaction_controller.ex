defmodule PeerLearningWeb.InitiateTransactionController do
  use PeerLearningWeb, :controller

  alias PeerLearning.Billings
  alias PeerLearning.Billing.InitiateTransaction
  alias PeerLearningWeb.Validators.{CourseOutlineValidator, Pagination}

  action_fallback PeerLearningWeb.FallbackController

  # def index(conn, params) do
  #   with {:ok, validated_params} <- Pagination.cast_and_validate(params),
  #        course_outlines <- Courses.list_course_outlines(validated_params) do
  #     conn
  #     |> put_status(200)
  #     |> render(:index, course_outlines: course_outlines)
  #   end
  # end

  # def show(conn, %{"id" => course_outline_id}) do
  #   with {:ok, %CourseOutline{} = course_outline} <- Courses.get_course_outline(course_outline_id) do
  #     conn
  #     |> put_status(200)
  #     |> render(:show, course_outline: course_outline)
  #   end
  # end

  def create(conn, %{"course_id" => course_id}) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, %InitiateTransaction{} = initiate_transaction} <-
           Billings.create_payment_intent(user, course_id) do
      conn
      |> put_status(:created)
      |> render(:show, initiate_transaction: initiate_transaction)
    end
  end

  def verify_payment_intent(conn, %{"payment_intent_id" => payment_intent_id}) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, initiate_transaction} <-
           Billings.verify_payment_intent(user, payment_intent_id) do
      conn
      # |> put_status(:created)
      |> render(:show, initiate_transaction: initiate_transaction)
    end
  end
end
