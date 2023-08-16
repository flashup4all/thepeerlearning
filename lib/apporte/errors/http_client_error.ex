defmodule PeerLearning.Errors.HTTPClientError do
  @moduledoc false

  defexception message: "HTTP request failed", reason: nil, status: 404

  @type t :: %__MODULE__{}

  def exception(message) when is_binary(message) do
    %__MODULE__{message: message}
  end

  def exception(opts) do
    status = Keyword.fetch!(opts, :status)
    reason = Keyword.get(opts, :reason, "timeout")

    %__MODULE__{
      message: "HTTP request failed due to: #{inspect(reason)}",
      status: status,
      reason: reason
    }
  end
end
