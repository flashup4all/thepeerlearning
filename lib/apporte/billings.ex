defmodule PeerLearning.Billings do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo

  alias PeerLearning.Accounts.{User, Children}
  alias PeerLearning.Courses.{Course}
  alias PeerLearning.Billing.{InitiateTransaction, Transaction}

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

  def verify_payment_intent(%User{} = user, payment_intent_id) do
    Repo.transaction(fn ->
      with {:ok, %InitiateTransaction{} = initiate_transaction} <-
             InitiateTransaction.get_by_gateway_ref(payment_intent_id),
           :initiated <- initiate_transaction.status,
           {:ok, %Stripe.PaymentIntent{} = payment_intent} <-
             Stripe.PaymentIntent.retrieve(payment_intent_id, %{}),
           "succeeded" <- payment_intent.status,
           {:ok, %Transaction{} = transaction} <-
             Transaction.create(user, initiate_transaction, %{
               amount: payment_intent.amount,
               purpose: :course_subscription,
               type: :credit,
               gateway_context: payment_intent,
               status: :success
             }),
           {:ok, %InitiateTransaction{} = initiate_transaction} <-
             InitiateTransaction.update(initiate_transaction, %{status: :completed}),
           {:ok, %User{} = user} <-
             User.update_user(user, %{registration_step: :completed}) do
        #  send transaction email notification job
        #  create course subscription via job
        PeerLearningEvents.course_service_to_create_user_courses(%{
          "type" => "create_user_courses",
          "payload" => %{
            "user_id" => user.id,
            "transaction_id" => transaction.id
          }
        })

        initiate_transaction
      else
        :completed ->
          {:ok, initiate_transaction} = InitiateTransaction.get_by_gateway_ref(payment_intent_id)
          # Repo.rollback(initiate_transaction)
          initiate_transaction

        {:error, error} ->
          Repo.rollback(error)

        error ->
          Repo.rollback(error)
      end
    end)
  end
end
