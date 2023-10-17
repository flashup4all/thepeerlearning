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

  defdelegate email_service_deliver_subscription_reciept_mail(payload),
    to: PeerLearningEvents.EmailServiceJob,
    as: :deliver_subscription_reciept_mail

  defdelegate course_service_to_create_user_courses(payload),
    to: PeerLearningEvents.CourseServiceJob,
    as: :create_user_courses

  defdelegate course_service_to_create_zoom_meeting_url_for_course_outline(payload),
    to: PeerLearningEvents.CourseServiceJob,
    as: :create_zoom_url_for_course_outline

  defdelegate email_service_deliver_welcome_mail(payload),
    to: PeerLearningEvents.EmailServiceJob,
    as: :deliver_welcome_mail
end
