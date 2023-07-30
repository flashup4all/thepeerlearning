# defmodule PeerLearningWeb.UserProfileControllerTest do
#   use PeerLearningWeb.ConnCase

#   import PeerLearning.AccountsFixtures

#   alias PeerLearning.Accounts.UserProfile

#   @create_attrs %{
#     address: "some address",
#     country: "some country",
#     dob: ~N[2023-03-18 14:54:00],
#     first_name: "some first_name",
#     gender: "some gender",
#     last_name: "some last_name",
#     state_province_of_origin: "some state_province_of_origin"
#   }
#   @update_attrs %{
#     address: "some updated address",
#     country: "some updated country",
#     dob: ~N[2023-03-19 14:54:00],
#     first_name: "some updated first_name",
#     gender: "some updated gender",
#     last_name: "some updated last_name",
#     state_province_of_origin: "some updated state_province_of_origin"
#   }
#   @invalid_attrs %{address: nil, country: nil, dob: nil, first_name: nil, gender: nil, last_name: nil, state_province_of_origin: nil}

#   setup %{conn: conn} do
#     {:ok, conn: put_req_header(conn, "accept", "application/json")}
#   end

#   describe "index" do
#     test "lists all user_profiles", %{conn: conn} do
#       conn = get(conn, ~p"/api/user_profiles")
#       assert json_response(conn, 200)["data"] == []
#     end
#   end

#   describe "create user_profile" do
#     test "renders user_profile when data is valid", %{conn: conn} do
#       conn = post(conn, ~p"/api/user_profiles", user_profile: @create_attrs)
#       assert %{"id" => id} = json_response(conn, 201)["data"]

#       conn = get(conn, ~p"/api/user_profiles/#{id}")

#       assert %{
#                "id" => ^id,
#                "address" => "some address",
#                "country" => "some country",
#                "dob" => "2023-03-18T14:54:00",
#                "first_name" => "some first_name",
#                "gender" => "some gender",
#                "last_name" => "some last_name",
#                "state_province_of_origin" => "some state_province_of_origin"
#              } = json_response(conn, 200)["data"]
#     end

#     test "renders errors when data is invalid", %{conn: conn} do
#       conn = post(conn, ~p"/api/user_profiles", user_profile: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end

#   describe "update user_profile" do
#     setup [:create_user_profile]

#     test "renders user_profile when data is valid", %{conn: conn, user_profile: %UserProfile{id: id} = user_profile} do
#       conn = put(conn, ~p"/api/user_profiles/#{user_profile}", user_profile: @update_attrs)
#       assert %{"id" => ^id} = json_response(conn, 200)["data"]

#       conn = get(conn, ~p"/api/user_profiles/#{id}")

#       assert %{
#                "id" => ^id,
#                "address" => "some updated address",
#                "country" => "some updated country",
#                "dob" => "2023-03-19T14:54:00",
#                "first_name" => "some updated first_name",
#                "gender" => "some updated gender",
#                "last_name" => "some updated last_name",
#                "state_province_of_origin" => "some updated state_province_of_origin"
#              } = json_response(conn, 200)["data"]
#     end

#     test "renders errors when data is invalid", %{conn: conn, user_profile: user_profile} do
#       conn = put(conn, ~p"/api/user_profiles/#{user_profile}", user_profile: @invalid_attrs)
#       assert json_response(conn, 422)["errors"] != %{}
#     end
#   end

#   describe "delete user_profile" do
#     setup [:create_user_profile]

#     test "deletes chosen user_profile", %{conn: conn, user_profile: user_profile} do
#       conn = delete(conn, ~p"/api/user_profiles/#{user_profile}")
#       assert response(conn, 204)

#       assert_error_sent 404, fn ->
#         get(conn, ~p"/api/user_profiles/#{user_profile}")
#       end
#     end
#   end

#   defp create_user_profile(_) do
#     user_profile = user_profile_fixture()
#     %{user_profile: user_profile}
#   end
# end
