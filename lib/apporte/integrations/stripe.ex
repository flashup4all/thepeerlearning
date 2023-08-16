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

    # def list_payment_request() do
    #   @http_client.get(@base_url <> "/paymentrequest", headers(), [])
    # end

    # def create_payment_request(%PaymentRequest{} = payment_request) do
    #   case @http_client.post(@base_url <> "/paymentrequest", Map.from_struct(payment_request), headers(), []) do
    #     {:ok, response} ->
    #       {:ok, response["data"]}

    #     {:error, error} ->
    #       {:error, error}
    #   end
    # end

    # def delete_payment_request(id_or_code) do
    #   case @http_client.post(@base_url <> "/paymentrequest/archive/#{id_or_code}", %{}, headers(), []) do
    #     {:ok, _response} ->
    #       :ok

    #     {:error, error} ->
    #       {:error, error}
    #   end
    # end

    # def create_customer(%Customer{} = customer) do
    #   case @http_client.post(@base_url <> "/customer", Map.from_struct(customer), headers(), []) do
    #     {:ok, response} ->
    #       {:ok, response["data"]}

    #     {:error, error} ->
    #       {:error, error}
    #   end
    # end

    # def update_customer(id_or_code, %Customer{} = customer) do
    #   case @http_client.put(@base_url <> "/customer/#{id_or_code}", Map.from_struct(customer), headers(), []) do
    #     {:ok, response} ->
    #       {:ok, response["data"]}

    #     {:error, error} ->
    #       {:error, error}
    #   end
    # end

    # def banks() do
    #   case @http_client.get(
    #          @base_url <> "/bank",
    #          headers(),
    #          []
    #        ) do
    #     {:ok, response} ->
    #       {:ok, response["data"]}

    #     {:error, %HTTPClientError{} = error} ->
    #       {:error, error}
    #   end
    # end

    # def resolve_bank_account(%{"account_number" => account_number, "bank_code" => bank_code}) do
    #   case @http_client.get(
    #          @base_url <> "/bank/resolve?account_number=#{account_number}&bank_code=#{bank_code}",
    #          headers(),
    #          []
    #        ) do
    #     {:ok, response} ->
    #       {:ok, response["data"]}

    #     {:error, %HTTPClientError{} = error} ->
    #       {:error, error}
    #   end
    # end

    # def validate_bank_account(payload) do
    #   case @http_client.post(@base_url <> "/bank/validate", payload, headers(), []) do
    #     {:ok, response} ->
    #       {:ok, response["data"]}

    #     {:error, error} ->
    #       {:error, error}
    #   end
    # end

    # def update_subaccount(id_or_code, sub_account) do
    #   case @http_client.put(@base_url <> "/subaccount/#{id_or_code}", sub_account, headers(), []) do
    #     {:ok, response} ->
    #       {:ok, response["data"]}

    #     {:error, error} ->
    #       {:error, error}
    #   end
    # end

    defp secret_key, do: Application.fetch_env!(:peer_learning, __MODULE__)[:api_secret_key]

    defp headers(), do: [{"authorization", "Bearer #{secret_key()}"}]
  end
