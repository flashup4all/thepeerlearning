# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
    # PeerLearning.Repo.insert!(%PeerLearning.SomeSchema{})
    alias PeerLearningWeb.Validators.{CourseValidator, RegisterUser, CreateUserProfile, CreateUser}

    # create courses
    [first_course | last_course] = [
        %PeerLearning.Courses.Course{
            title: "Web Development",
            description: "Our web development curriculum pathway is designed to teach kids the skills they need to become a successful web developer. The pathway is divided into four courses: kids will learn everything they need to know to create beautiful responsive websites from scratch.",
            amount: 120000, # in cents
            default_currency: "USD",
            age_range: "10-13",
            level: "2",
            unique_name: "web_dev",
        },
        %PeerLearning.Courses.Course{
            title: "Game Design  ",
            description: "This is where it all begins! This pathway is designed to help students learn the fundamentals of coding and computational thinking in a fun and engaging way while designing their own games and animations. The pathway is divided into three levels, each of which builds on the skills learned in the previous level.",
            amount: 120000, # in cents
            default_currency: "USD",
            age_range: "7-9",
            level: "1",
            unique_name: "game_dev",
        },
    ]
    
    # create instructor
    instructor = 
    %RegisterUser{
        user: %CreateUser{
            email: "instructor4@gmail.com",
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
    PeerLearning.Repo.insert(%PeerLearning.Courses.Course{
        title: "Web Development",
        description: "Our web development curriculum pathway is designed to teach kids the skills they need to become a successful web developer. The pathway is divided into four courses: kids will learn everything they need to know to create beautiful responsive websites from scratch.",
        amount: 120000, # in cents
        default_currency: "USD",
        age_range: "10-13",
        level: "2",
        unique_name: "web_dev4",
    })
    PeerLearning.Repo.insert(%PeerLearning.Courses.Course{
        title: "Game Design  ",
        description: "This is where it all begins! This pathway is designed to help students learn the fundamentals of coding and computational thinking in a fun and engaging way while designing their own games and animations. The pathway is divided into three levels, each of which builds on the skills learned in the previous level.",
        amount: 120000, # in cents
        default_currency: "USD",
        age_range: "7-9",
        level: "1",
        unique_name: "game_dev4",
    })
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
