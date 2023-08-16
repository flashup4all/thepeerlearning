defmodule PeerLearning.Repo.Migrations.CreateClassScheduleDrafts do
  use Ecto.Migration

  def change do
    create table(:schedule_drafts) do
      add :content, :string
      add :user_id, references(:users)

      timestamps()
    end

    create index(:schedule_drafts, [:user_id])
  end
end
