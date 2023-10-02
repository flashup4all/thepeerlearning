defmodule PeerLearning.Integrations.Zoom do
  @moduledoc false
  @http_client Application.compile_env!(:peer_learning, :http_client)
  @base_url Application.compile_env!(:peer_learning, __MODULE__)[:base_url]
  @oauth_base_url Application.compile_env!(:peer_learning, __MODULE__)[:oauth_base_url]
  @account_id Application.compile_env!(:peer_learning, __MODULE__)[:account_id]

  alias PeerLearning.Integrations.Stripe.PaymentIntent

  alias FullGap.Errors.HTTPClientError
  require Logger

  def create_oauth_token(payload \\ %{}) do
    case @http_client.post(
           @oauth_base_url <>
             "/oauth/token?grant_type=account_credentials&account_id=#{@account_id}",
           payload,
           headers(),
           []
         ) do
      {:ok, response} ->
        {:ok, response}

      {:error, error} ->
        # Logger.info("CustomerIO: successfully created customer.")
        {:error, error}
    end
  end

  def create_meeting(payload, token) do
    (@base_url <> "/users/me/meetings")
    {:ok, response} = create_oauth_token()

    case @http_client.post(
           @base_url <> "/users/me/meetings",
           payload,
           [
             {"Authorization", "Bearer #{token}"},
             {"Content-Type", "application/json"}
           ],
           []
         ) do
      {:ok, response} ->
        {:ok, response}

      {:error, error} ->
        error
        # Logger.info("CustomerIO: successfully created customer.")
        {:error, error}
    end
  end

  defp secret_key, do: Base.encode64("WVf15mMT5mCuWpllzo8Ig:LxMe3x4QQWffO8bEe4TP3jWXVnU0mb0D")

  defp headers(), do: [{"Authorization", "Basic #{secret_key()}"}]
end
