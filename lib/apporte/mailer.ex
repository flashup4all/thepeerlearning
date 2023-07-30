defmodule PeerLearning.Mailer do
  use Bamboo.Mailer, otp_app: :peer_learning
  # use Mailgun.Client,
  #       domain: Application.compile_env(:peer_learning, :mailgun_domain),
  #       key: Application.compile_env(:peer_learning, :mailgun_key)
end
