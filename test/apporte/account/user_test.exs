defmodule PeerLearning.Accounts.UserTest do
  use PeerLearning.DataCase

  alias PeerLearning.Accounts.User
  alias PeerLearning.Factory

  describe "fields/0" do
    test "success: fields match" do
      expected_fields = [
        :bvn,
        :deleted_at,
        :email,
        :is_active,
        :is_bvn_verified,
        :is_email_verified,
        :is_phone_number_verified,
        :metadata,
        :password_hash,
        :phone_number,
        :role,
        :user_type,
        :updated_at,
        :inserted_at,
        :id
      ]

      assert Enum.sort(expected_fields) == Enum.sort(User.fields())
    end
  end

  describe "create_user/1" do
    test "success: it inserts a Apport.Accounts.User record in the db" do
      user_params = Factory.params_for(:user)

      assert {:ok, created_user} = User.create_user(user_params)

      assert_values_for(
        expected: user_params,
        actual: created_user,
        fields: [:email, :phone_number, :user_type, :role]
      )

      assert created_user.password_hash
    end

    test "error: it returns an error for missing required fields" do
      user_params = Factory.params_for(:user)

      user_params = %{user_params | phone_number: "", email: "", password: ""}

      assert {:error, %Ecto.Changeset{}} = User.create_user(user_params)
    end
  end

  describe "get_user_by_email/1" do
    test "success: gets a Apport.Accounts.User record when given a valid email" do
      assert [first_user | _] = Factory.insert_list(3, :user)
      assert {:ok, %User{} = user} = User.get_user_by_email(first_user.email)

      assert_values_for(
        expected: first_user,
        actual: user,
        fields: [:email, :phone_number, :user_type, :role]
      )

      assert first_user.email == user.email
    end

    test "error: it returns not_found when given a non existent email" do
      _users = Factory.insert_list(5, :user)
      email = Faker.Internet.email()

      assert {:error, :not_found} = User.get_user_by_email(email)
    end
  end

  describe "verify_password/1" do
    test "success: returns true when verifying a Apport.Accounts.User password when given a valid password" do
      user_params = Factory.params_for(:user)
      assert {:ok, %User{} = user} = User.create_user(user_params)

      assert true == User.verify_password(user, user_params.password)
    end

    test "error: returns false when verifying a Apport.Accounts.User password when given a invalid password" do
      user_params = Factory.params_for(:user)
      assert {:ok, %User{} = user} = User.create_user(user_params)
      password = "1234"

      assert false == User.verify_password(user, password)
    end
  end
end
