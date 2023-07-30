defmodule PeerLearning.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password_hash, :binary
      add :user_type, :string
      add :role, :string
      add :phone_number, :string
      add :is_active, :boolean, default: false, null: false
      add :is_bvn_verified, :boolean, default: false, null: false
      add :bvn, :string
      add :registration_step, :string
      add :metadata, :map
      add :deleted_at, :naive_datetime
      add :is_email_verified, :boolean, default: false, null: false
      add :is_phone_number_verified, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users, :email)
  end
end
