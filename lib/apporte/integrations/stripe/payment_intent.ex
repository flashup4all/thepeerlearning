defmodule PeerLearning.Integrations.Stripe.PaymentIntent do
  @moduledoc false
  defstruct [:amount, :currency, :automatic_payment_methods, :customer, :metadata]

end
