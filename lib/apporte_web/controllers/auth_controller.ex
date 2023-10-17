defmodule PeerLearningWeb.AuthController do
  use PeerLearningWeb, :controller
  alias PeerLearning.Auth

  action_fallback PeerLearningWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password} = params) do
    with {:ok, %{user: user, token: token}} <- Auth.login(email, password) do
      conn
      |> put_status(200)
      |> render("auth.json", %{
        token: token,
        user: user
      })
    end
  end

  def send_mail(conn, _params) do
    PeerLearning.EmailService.deliver_test_mail(%{"email" => "flashup4all@gmail.com"})
    # PeerLearningEvents.email_service_deliver_email_confirmation(%{
    #   "type" => "deliver_email_verification",
    #   "payload" => %{
    #     "email" => "flashup4all@gmail.com"
    #   }
    # })
  end
end
