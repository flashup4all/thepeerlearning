defmodule PeerLearning.Repo do
  require Logger
  use Ecto.Repo,
    otp_app: :peer_learning,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: Application.compile_env!(:peer_learning, :default_pagination)

  # def init(_type, config) do
  #   database_url = System.get_env("DATABASE_URL")
  #   if database_url == nil do
  #     Logger.debug "$DATABASE_URL not set, using config"
  #     {:ok, config}
  #   else
  #     Logger.debug "Configuring database using $DATABASE_URL"
  #     {:ok, Keyword.put(config, :url, database_url)}
  #   end
  # end
end
