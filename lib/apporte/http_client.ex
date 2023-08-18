defmodule PeerLearning.HTTPClient do
  @moduledoc false
  alias PeerLearning.Errors.HTTPClientError

  @default_headers [{"content-type", "application/json"}]

  @callback post(String.t(), term(), Keyword.t(), Keyword.t()) ::
              {:ok, map() | Finch.Response.t()} | {:error, term()}
  def post(url, body, headers \\ [], options \\ []) do
    maybe_post_or_put(:post, url, body, headers, options)
  end

  @callback put(String.t(), term(), Keyword.t(), Keyword.t()) ::
              {:ok, map() | Finch.Response.t()} | {:error, term()}
  def put(url, body, headers \\ [], options \\ []) do
    maybe_post_or_put(:put, url, body, headers, options)
  end

  @callback get(String.t(), Keyword.t(), Keyword.t()) ::
              {:ok, map() | Finch.Response.t()} | {:error, term()}
  def get(url, headers \\ [], options \\ []) do
    headers = @default_headers ++ headers

    Finch.build(:get, URI.encode(url), headers, options)
    |> Finch.request(PeerLearning.Finch, pool_timeout: 10_000)
    |> case do
      {:ok, %Finch.Response{status: status, body: response_body}} when status in 200..299 ->
        Jason.decode(response_body)

      {:ok, %Finch.Response{status: status}} ->
        {:error, HTTPClientError.exception(status: status)}

      {:error, reason} ->
        {:error, HTTPClientError.exception(reason: reason, status: 500)}
    end
  end

  defp maybe_post_or_put(request_type, url, body, headers, options)
       when request_type in [:post, :put] do
    IO.inspect(options)

    with {:ok, encoded_body} <- Jason.encode(body),
         %Finch.Request{} =
           request =
           Finch.build(request_type, URI.encode(url), headers, encoded_body, options)
           |> IO.inspect(),
         {:ok, %Finch.Response{status: status, body: response_body}} when status in 200..299 <-
           Finch.request(request, PeerLearning.Finch),
         {:ok, decoded_response} <- decode_or_return_raw(response_body) do
      {:ok, decoded_response}
    else
      # hack to handle paystack specific response style.
      {:ok, %Finch.Response{status: status, body: reason} = response} when status in [400] ->
        IO.inspect(response)

        case Jason.decode(reason) do
          {:ok, %{"status" => false, "message" => message}} ->
            {:error, message}

          # AYO-DO this is not paystack, but a general catch all.
          _ ->
            {:error, HTTPClientError.exception(status: status, reason: reason)}
        end

      {:ok, %Finch.Response{status: status, body: reason}} ->
        {:error, HTTPClientError.exception(status: status, reason: Jason.encode(reason))}

      {:error, reason} ->
        {:error, HTTPClientError.exception(reason: reason, status: 500)}
    end
  end

  defp decode_or_return_raw(response_body) do
    case Jason.decode(response_body) do
      {:ok, decoded_response} -> {:ok, decoded_response}
      {:error, _non_json_response} -> {:ok, response_body}
    end
  end
end
