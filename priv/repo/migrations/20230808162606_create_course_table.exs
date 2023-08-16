defmodule PeerLearning.Repo.Migrations.CreateCourseTable do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :title, :string
      add :level, :string
      add :unique_name, :string
      add :description, :text
      add :amount, :integer
      add :default_currency, :string
      add :age_range, :string
      add :is_active, :boolean
      add :metadata, :map, null: true
      add :deleted_at, :utc_datetime_usec, null: true

      timestamps()
    end

    create unique_index(:courses, :unique_name)
  end
end
