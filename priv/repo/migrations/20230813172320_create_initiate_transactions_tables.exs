defmodule PeerLearning.Repo.Migrations.CreateInitiateTransactionsTables do
  use Ecto.Migration

  def change do
    create table(:initiate_transactions) do
      add :amount, :integer
      add :provider, :string
      add :gateway_ref, :string
      add :metadata, :map
      add :status, :string
      add :user_id, references(:users)
      add :resource_id, :string
      add :resource_type, :string
      add :deleted_at, :utc_datetime_usec, null: true

      timestamps()
    end
  end
end
