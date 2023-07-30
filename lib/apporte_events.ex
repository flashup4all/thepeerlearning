defmodule PeerLearningEvents do
  @moduledoc false

  defdelegate email_service_deliver_email_confirmation(payload),
    to: PeerLearningEvents.EmailServiceJob,
    as: :deliver_email_verification

  defdelegate email_service_deliver_forgot_password_url(payload),
    to: PeerLearningEvents.EmailServiceJob,
    as: :deliver_forgot_password_url

  defdelegate email_service_deliver_updated_password_mail(payload),
    to: PeerLearningEvents.EmailServiceJob,
    as: :deliver_updated_password_mail
end
