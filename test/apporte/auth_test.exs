defmodule PeerLearning.AuthTest do
  use PeerLearning.DataCase

  alias PeerLearning.Factory
  alias PeerLearning.Auth
  alias PeerLearning.Accounts
  alias PeerLearning.Accounts.User

  describe "login/1" do
    test "success: it authenticates a App.Accounts.User when valid params is given" do
      user_params = Factory.build(:user_validator)
      assert {:ok, %User{} = created_user} = Auth.create_user(user_params)

      assert {:ok, %{user: %User{} = user, token: _}} =
               Auth.login(user_params.email, user_params.password)

      assert_values_for(
        expected: created_user,
        actual: user,
        fields: [:email, :phone_number, :user_type, :role]
      )
    end

    test "error: it returns an :unauthorized when given invalid params" do
      user_params = Factory.build(:user_validator)
      assert {:ok, %User{}} = Auth.create_user(user_params)

      email = Faker.Internet.email()
      password = Factory.valid_password()

      assert {:error, :custom, :bad_request, "Error", "Email/Passwords do not match"} =
               Auth.login(email, password)
    end

    test "error: it returns an validation error when one email is valid" do
      user_params = Factory.build(:user_validator)
      assert {:ok, %User{}} = Auth.create_user(user_params)

      password = Factory.valid_password()
      assert {:error, %Ecto.Changeset{}} = Auth.login(user_params.email, password)
    end
  end
end
