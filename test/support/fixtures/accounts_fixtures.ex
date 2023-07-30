defmodule PeerLearning.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PeerLearning.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        bvn: "some bvn",
        deleted_at: ~N[2023-03-16 11:31:00],
        email: "some email",
        is_active: true,
        is_bvn_verified: true,
        is_email_verified: true,
        is_phone_number_verified: true,
        metadata: %{},
        password_hash: "some password_hash",
        phone_number: "some phone_number",
        role: "some role",
        user_type: "some user_type"
      })
      |> PeerLearning.Accounts.create_user()

    user
  end

  @doc """
  Generate a user_profile.
  """
  def user_profile_fixture(attrs \\ %{}) do
    {:ok, user_profile} =
      attrs
      |> Enum.into(%{
        address: "some address",
        country: "some country",
        dob: ~N[2023-03-18 14:54:00],
        first_name: "some first_name",
        gender: "some gender",
        last_name: "some last_name",
        state_province_of_origin: "some state_province_of_origin"
      })
      |> PeerLearning.Accounts.create_user_profile()

    user_profile
  end
end
