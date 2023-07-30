defmodule PeerLearningWeb.Plug.AuthAccessPipeline do
  @moduledoc false
  use Guardian.Plug.Pipeline, otp_app: :peer_learning

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true
end
