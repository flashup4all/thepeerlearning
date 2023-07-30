defmodule PeerLearning.Repo.Migrations.CreateUserProfiles do
  use Ecto.Migration

  def change do
    create table(:user_profiles) do
      add :fullname, :string
      add :dob, :naive_datetime
      add :gender, :string
      add :state_province_of_origin, :string
      add :address, :string
      add :country, :string
      add :user_id, references(:users)

      timestamps()
    end

    create index(:user_profiles, [:user_id])
  end
end
