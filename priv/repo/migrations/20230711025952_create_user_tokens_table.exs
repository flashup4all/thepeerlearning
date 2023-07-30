defmodule PeerLearning.Repo.Migrations.CreateUserTokensTable do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :token, :binary
      add :context, :string

      add :status, :string

      add :user_id, references(:users)

      timestamps()
    end
  end
end
