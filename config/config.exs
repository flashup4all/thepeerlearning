# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :peer_learning,
  ecto_repos: [PeerLearning.Repo],
  generators: [binary_id: true]

config :peer_learning, PeerLearning.Repo,
  migration_primary_key: [type: :binary_id, autogenerate: false],
  migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :peer_learning, PeerLearningWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: PeerLearningWeb.ErrorHTML, json: PeerLearningWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PeerLearning.PubSub,
  live_view: [signing_salt: "0zkVSC3r"]

# Argon2 configuration
config :argon2_elixir,
  t_cost: 6,
  m_cost: 16,
  parallelism: 2

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :peer_learning, PeerLearning.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :peer_learning, PeerLearningWeb.Auth.Guardian,
  issuer: "peer_learning",
  secret_key: "+Dk0RjCbKxetLhvOD1CQjY02pgvCgzzy22WXYi2Cwtk3iXEngBWGmTo0RbsNH/v+"

config :peer_learning, PeerLearningWeb.Plug.AuthAccessPipeline,
  module: PeerLearningWeb.Auth.Guardian,
  error_handler: PeerLearningWeb.Auth.AuthErrorHandler

# transactional email gateway providers
default_email_provider =
  System.get_env("DEFAULT_EMAIL_PROVIDER") ||
    raise """
    environment variable DEFAULT_EMAIL_PROVIDER is missing.
    """

# pagination
default_pagination =
  System.get_env("DEFAULT_PAGINATION") ||
    raise """
    environment variable DEFAULT_PAGINATION is missing.
    """

config :peer_learning,
  default_pagination: default_pagination,
  email_provider: default_email_provider,
  web_endpoint: "http://localhost:3000"

sentry_dsn =
  System.get_env("SENTRY_DSN") ||
    raise """
    environment variable SENTRY_DSN is missing.
    """

config :sentry,
  dsn: sentry_dsn,
  environment_name: :prod,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

mailgun_api_key =
  System.get_env("MAILGUN_API_KEY") ||
    raise """
    environment variable MAILGUN_API_KEY is missing.
    """

mailgun_domain =
  System.get_env("MAILGUN_DOMAIN") ||
    raise """
    environment variable MAILGUN_DOMAIN is missing.
    """

config :peer_learning, PeerLearning.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: mailgun_api_key,
  domain: mailgun_domain,
  base_uri: "https://api.eu.mailgun.net/v3",
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]

config :peer_learning, Oban,
  repo: PeerLearning.Repo,
  queues: [default: 10]

# config :swoosh, :api_client, Swoosh.ApiClient.Hackney
# config :peer_learning,
#   mailgun_domain: mailgun_domain,
#   mailgun_key: mailgun_api_key

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
