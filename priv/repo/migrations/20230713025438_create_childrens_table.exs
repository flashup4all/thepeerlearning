defmodule PeerLearning.Repo.Migrations.CreateChildrensTable do
  use Ecto.Migration

  def change do
    create table(:children) do
      add :fullname, :string
      add :date_of_birth, :naive_datetime
      add :gender, :string
      add :is_active, :boolean
      add :username, :string
      add :password_hash, :string
      add :user_id, references(:users)

      timestamps()
    end

    create index(:children, [:user_id])
  end
end
