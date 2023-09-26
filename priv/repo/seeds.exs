# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
    # PeerLearning.Repo.insert!(%PeerLearning.SomeSchema{})
    alias PeerLearningWeb.Validators.{RegisterUser, CreateUserProfile, CreateUser}
    instructor = 
    %RegisterUser{
        user: %CreateUser{
            email: "instructor@gmail.com",
            password: "Ahe@d123",
            phone_number: "2348032413264",
            user_type: "user"
        },
        instructor: %CreateUserProfile{
           fullname: "John Doe",
           country: "Nigeria"
        }
    }
    PeerLearning.Auth.create_instructor(instructor)
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
