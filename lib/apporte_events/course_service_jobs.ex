defmodule PeerLearningEvents.CourseServiceJob do
  @moduledoc false
  use Oban.Worker, max_attempts: 2

  alias PeerLearning.Courses
  require Logger

  @valid_type [
    "create_user_courses"
  ]

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"type" => type, "payload" => payload}})
      when type in @valid_type do
    do_perform(String.to_atom(type), payload)
  end

  def create_user_courses(payload) do
    payload
    |> new(priority: 2)
    |> Oban.insert()
  end

  defp do_perform(:create_user_courses, payload) do
    :ok = Logger.info("begin processing create_user_courses job")
    _ = Courses.create_user_courses(payload["user_id"], payload["transaction_id"])
    :ok = Logger.info("end processing create_user_courses job")
  end
end