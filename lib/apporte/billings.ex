defmodule PeerLearning.Billings do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo

  alias PeerLearning.Accounts.{User}
  alias PeerLearning.Courses.{Course}
  alias PeerLearning.Billing.{InitiateTransaction}

  def money_to_string(amount) do
    Money.to_string(amount, separator: "", delimiter: "", symbol: false)
  end

  def money_to_integer(amount) do
    money_to_string(amount) |> String.to_integer()
  end

  def create_payment_intent(%User{} = user, course_id) do
    Repo.transaction(fn ->
      with {:ok, %Course{} = course} <- Course.get_course(course_id),
           {:ok, %Stripe.PaymentIntent{} = payment_intent} <-
             Stripe.PaymentIntent.create(%{
               amount: money_to_integer(course.amount),
               currency: "USD",
               automatic_payment_methods: %{
                 enabled: true
               },
               metadata: %{
                 resource_id: user.id
               }
             }),
           {:ok, %InitiateTransaction{} = initiate_transaction} <-
             InitiateTransaction.create(user, %{
               amount: payment_intent.amount,
               provider: :stripe,
               gateway_ref: payment_intent.id,
               metadata: %{
                 client_secret: payment_intent.client_secret,
                 payment_intent_id: payment_intent.id
               },
               resource_id: course.id,
               resource_type: :course
             }) do
        initiate_transaction
      else
        {:error, error} ->
          {:error, error}
          Repo.rollback(error)

        error ->
          {:error, error}
          Repo.rollback(error)
      end
    end)
  end
end
