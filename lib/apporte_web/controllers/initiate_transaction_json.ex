defmodule PeerLearningWeb.InitiateTransactionJSON do
  alias PeerLearning.Billing.InitiateTransaction

  @doc """
  Renders a list of courses.
  """
  def index(%{initiate_transactions: initiate_transactions}) do
    %{
      data:
        for(initiate_transaction <- initiate_transactions.entries, do: data(initiate_transaction)),
      page_number: initiate_transactions.page_number,
      page_size: initiate_transactions.page_size,
      total_entries: initiate_transactions.total_entries,
      total_pages: initiate_transactions.total_pages
    }
  end

  @doc """
  Renders a single courses.
  """
  def show(%{initiate_transaction: initiate_transaction}) do
    %{data: data(initiate_transaction)}
  end

  def data(%InitiateTransaction{} = initiate_transaction) do
    %{
      id: initiate_transaction.id,
      user_id: initiate_transaction.user_id,
      gateway_ref: initiate_transaction.gateway_ref,
      provider: initiate_transaction.provider,
      status: initiate_transaction.status,
      resource_id: initiate_transaction.resource_id,
      resource_type: initiate_transaction.resource_type,
      amount:
        Money.to_string(initiate_transaction.amount, separator: "", delimiter: "", symbol: false),
      pretty_amount: Money.to_string(initiate_transaction.amount),
      metadata: initiate_transaction.metadata,
      inserted_at: initiate_transaction.inserted_at,
      updated_at: initiate_transaction.updated_at
    }
  end
end
