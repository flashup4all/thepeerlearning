defmodule PeerLearning.Repo do
  require Logger

  use Ecto.Repo,
    otp_app: :peer_learning,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: Application.compile_env!(:peer_learning, :default_pagination)
end
