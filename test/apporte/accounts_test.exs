defmodule PeerLearning.AccountsTest do
  use PeerLearning.DataCase

  alias PeerLearning.Factory
  alias PeerLearning.{Accounts, Auth}
  alias PeerLearning.Accounts.User
  alias PeerLearning.Accounts.UserProfile

  describe "create_user/1" do
    test "success: it inserts a Apport.Accounts.User account in the db when valid params is given" do
      user_params = Factory.build(:user_validator)

      assert {:ok, %User{user_profile: user_profile} = created_user} =
               Auth.create_user(user_params)

      assert_values_for(
        expected: user_params,
        actual: created_user,
        fields: [:email, :phone_number, :user_type, :role]
      )

      assert created_user.email == user_params.email
      assert created_user.phone_number == user_params.phone_number
      assert user_profile.user_id == created_user.id
    end

    test "error: it returns an error for missing required fields" do
      user_params = Factory.build(:user_validator)

      user_params = %{user_params | phone_number: "", email: "", password: ""}

      assert {:error, %Ecto.Changeset{}} = Auth.create_user(user_params)
    end
  end

  describe "update_user_profile/2" do
    test "success: it updates a Apport.Accounts.UserProfile account in the db when valid params is given" do
      user_params = Factory.build(:user_validator)
      assert {:ok, %User{} = user} = Auth.create_user(user_params)

      user_profile_params = Factory.params_for(:user_profile_validator)

      assert {:ok, %UserProfile{} = returned_user_profile} =
               Accounts.update_user_profile(user.id, user_profile_params)

      assert_values_for(
        expected: user_profile_params,
        actual: returned_user_profile,
        fields: [:fullname]
      )

      assert user.id == returned_user_profile.user_id
    end
  end
end
