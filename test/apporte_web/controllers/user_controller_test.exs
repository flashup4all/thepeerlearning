defmodule PeerLearningWeb.UserControllerTest do
  use PeerLearningWeb.ConnCase

  alias PeerLearningWeb.Auth.Guardian
  alias PeerLearning.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup %{conn: conn} do
    user = Factory.insert(:user)
    profile = Factory.insert(:user_profile, user: user)

    {:ok, token, _claims} = Guardian.encode_and_sign(user, token_type: "refresh")

    conn_with_token =
      conn
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn_with_token: conn_with_token, user: user}
  end

  describe "register/2" do
    test "renders user when data is valid", %{conn: conn, user: user} do
      params = Factory.string_params_for(:user_validator)

      assert response =
               post(conn, ~p"/api/v1/onboarding/register", params)
               |> json_response(201)
    end

    test "error: renders user when data is invalid", %{conn: conn, user: user} do
      params = Factory.string_params_for(:user_validator)
      params = %{params | "email" => ""}

      assert response =
               post(conn, ~p"/api/v1/onboarding/register", params)
               |> json_response(422)
    end
  end
end
