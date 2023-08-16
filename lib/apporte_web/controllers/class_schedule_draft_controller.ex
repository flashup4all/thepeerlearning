defmodule PeerLearningWeb.ClassScheduleDraftController do
  use PeerLearningWeb, :controller

  alias PeerLearning.{Courses}
  alias PeerLearning.Courses.{ClassScheduleDraft}
  alias PeerLearningWeb.Validators.{UserClassSchedule}

  action_fallback PeerLearningWeb.FallbackController

  def create(conn, params) do
    user = PeerLearningWeb.Auth.Guardian.Plug.current_resource(conn, [])

    with {:ok, validated_params} <- UserClassSchedule.cast_and_validate(params),
         {:ok, %ClassScheduleDraft{} = class_schedule_draft} <-
           Courses.create_schedule_draft(user, validated_params) do
      conn
      |> put_status(:created)
      |> json(%{
        data: Jason.decode!(class_schedule_draft.content),
        status: "success"
      })
    end
  end

  # def update(conn, %{"id" => child_id} = params) do

  #   with {:ok, validated_params} <- UpdateChild.cast_and_validate(params),
  #   {:ok, %Children{} = child} <- Accounts.update_child(child_id, validated_params) do
  #     conn
  #     |> put_status(200)
  #     |> render(:show, children: child)
  #   end
  # end

  # def delete(conn, %{"id" => child_id}) do
  #   {:ok, %Children{} = child} = Accounts.delete_child(child_id)
  #     conn
  #     |> put_status(200)
  #     |> render(:show, children: child)
  # end
end
