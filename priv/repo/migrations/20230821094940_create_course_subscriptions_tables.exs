defmodule PeerLearning.Repo.Migrations.CreateCourseSubscriptionsTables do
  use Ecto.Migration

  def change do
    create table(:course_subscriptions) do
      add :timezone, :string
      add :description, :string
      add :feedback, :text
      add :rating, :integer
      add :is_active, :boolean
      add :is_expired, :boolean
      add :start_date, :utc_datetime_usec
      add :end_date, :utc_datetime_usec
      add :user_id, references(:users)
      add :children_id, references(:children)
      add :course_id, references(:courses)
      add :transaction_id, references(:transactions)

      timestamps()
    end
  end
end
