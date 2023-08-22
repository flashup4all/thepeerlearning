defmodule PeerLearning.Repo.Migrations.CreateCourseOutlinesTables do
  use Ecto.Migration

  def change do
    create table(:course_outlines) do
      add :title, :string
      add :description, :text
      add :content, :text
      add :is_active, :boolean
      add :order, :integer
      add :deleted_at, :utc_datetime_usec, null: true
      add :course_id, references(:courses)

      timestamps()
    end
  end
end
