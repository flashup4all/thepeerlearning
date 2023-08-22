defmodule PeerLearning.EmailService do
  @moduledoc false
  import Bamboo.Email
  import Bamboo.MailgunHelper
  alias PeerLearning.Mailer

  defp base_email() do
    new_email()
    |> from("hello@thepeerlearning.com")
  end

  def deliver_email_verification(payload) do
    web_endpoint = Application.fetch_env!(:peer_learning, :web_endpoint)

    to_email = payload["email"]
    hashed_token = payload["hashed_token"]
    first_name = payload["first_name"]
    _last_name = payload["last_name"]

    base_email()
    |> to(to_email)
    |> subject("[The Peer Learning] Account Verification")
    |> template("email-verification")
    |> substitute_variables(%{
      "first_name" => first_name,
      "password_reset_link" =>
        "#{web_endpoint}/account/verification/#{hashed_token}/#{Base.url_encode64(to_email, padding: false)}"
    })
    |> Mailer.deliver_now()

    :ok
  end

  def deliver_welcome_mail(payload) do
    web_endpoint = Application.fetch_env!(:peer_learning, :web_endpoint)

    to_email = payload["email"]
    hashed_token = payload["hashed_token"]
    first_name = payload["first_name"]
    last_name = payload["last_name"]

    base_email()
    |> to(to_email)
    |> subject("[The Peer Learning] Welcome!")
    |> template("email-verification")
    |> substitute_variables(%{
      "first_name" => first_name,
      "password_reset_link" => "#{web_endpoint}/login"
    })
    |> Mailer.deliver_now()

    :ok
  end

  def deliver_forgot_password_url(payload) do
    web_endpoint = Application.fetch_env!(:peer_learning, :web_endpoint)

    to_email = payload["email"]
    hashed_token = payload["hashed_token"]
    first_name = payload["first_name"]
    last_name = payload["last_name"]

    base_email()
    |> to(to_email)
    |> subject("[The Peer Learning] Reset Password")
    |> template("email-verification")
    |> substitute_variables(%{
      "first_name" => first_name,
      "password_reset_link" =>
        "#{web_endpoint}/email/reset/#{hashed_token}/#{Base.url_encode64(to_email, padding: false)}"
    })
    |> Mailer.deliver_now()

    :ok
  end

  def deliver_updated_password_mail(payload) do
    web_endpoint = Application.fetch_env!(:peer_learning, :web_endpoint)

    to_email = payload["email"]
    first_name = payload["first_name"]
    _last_name = payload["last_name"]

    base_email()
    |> to(to_email)
    |> subject("[The Peer Learning] Password Updated")
    |> template("updated-password")
    |> substitute_variables(%{
      "first_name" => first_name,
      "password_reset_link" => "#{web_endpoint}/login"
    })
    |> Mailer.deliver_now()

    :ok
  end

  def deliver_subscription_reciept_mail(payload) do
    web_endpoint = Application.fetch_env!(:peer_learning, :web_endpoint)

    to_email = payload["email"]
    first_name = payload["first_name"]
    _last_name = payload["last_name"]

    base_email()
    |> to(to_email)
    |> subject("[The Peer Learning] Password Updated")
    |> template("updated-password")
    |> substitute_variables(%{
      "first_name" => first_name,
      "password_reset_link" => "#{web_endpoint}/login"
    })
    |> Mailer.deliver_now()

    :ok
  end
end
