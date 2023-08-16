defmodule PeerLearning.Integrations.Stripe do
    @moduledoc false
    @http_client Application.compile_env!(:peer_learning, :http_client)
    @base_url Application.compile_env!(:peer_learning, __MODULE__)[:base_url]

    alias PeerLearning.Integrations.Stripe.PaymentIntent

    alias FullGap.Errors.HTTPClientError
    require Logger

    def create_payment_intent(%PaymentIntent{} = payload) do
      IO.inspect Map.from_struct(payload)
      case @http_client.post(@base_url <> "/payment_intents", Map.from_struct(payload), headers(), []) do
        {:ok, response} ->
          IO.inspect response
          {:ok, response}

        {:error, error} ->
          # Logger.info("CustomerIO: successfully created customer.")
          {:error, error}
      end
    end

    defp secret_key, do: Application.fetch_env!(:peer_learning, __MODULE__)[:api_secret_key]

    defp headers(), do: [{"authorization", "Bearer #{secret_key()}"}]
  end
