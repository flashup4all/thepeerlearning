defmodule PeerLearning.Repo.Migrations.CreateUserCoursesOutlinesTable do
  use Ecto.Migration

  def change do
    create table(:user_course_outlines) do
      add :status, :string
      add :meeting_url, :string
      add :notes, :text
      add :child_feedback, :text
      add :instructor_feedback, :text
      add :assignment, :text
      add :instructor_status, :string
      add :child_status, :string
      add :metadata, :map
      add :date, :utc_datetime_usec
      add :time, :string

      # add :instructor_id, references(:users)
      add :user_id, references(:users)
      add :children_id, references(:children)
      add :course_outline_id, references(:course_outlines)
      add :course_subscription_id, references(:course_subscriptions)
      timestamps()
    end
  end
end
