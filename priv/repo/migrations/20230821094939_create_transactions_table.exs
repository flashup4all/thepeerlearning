defmodule PeerLearning.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :integer
      add :currency, :string
      add :provider, :string
      add :gateway_ref, :string
      add :status, :string
      add :type, :string
      add :purpose, :string
      add :metadata, :map
      add :fee, :integer
      add :gateway_fee, :integer
      add :gateway_context, :map
      add :user_id, references(:users)
      add :initiate_transaction_id, references(:initiate_transactions)

      timestamps()
    end
  end
end
