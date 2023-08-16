defmodule PeerLearning.Repo.Migrations.CreateTransactionsTables do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      # new fields to come eg. amount, payment channel etc
      add :user_id, references(:users)

      timestamps()
    end
  end
end
