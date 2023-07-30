import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :peer_learning, PeerLearning.Repo,
  username: "postgres",
  password: "",
  hostname: "localhost",
  database: "peer_learning_#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :peer_learning, PeerLearningWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "A1HFS9slrE5DMfW77y2RMqmr+i53AO4GNsPWkO5U+NR1x96jVxhWqyGeBXBU3qF+",
  server: false

# In test we don't send emails.
config :peer_learning, PeerLearning.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

config :my_app, Oban, testing: :inline
# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
