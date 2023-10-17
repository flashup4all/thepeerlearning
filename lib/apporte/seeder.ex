defmodule PeerLearning.DefaultSeeder do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PeerLearning.Repo
  alias PeerLearning.Integrations.Zoom

  alias PeerLearning.Accounts.{User, UserProfile}

  alias PeerLearning.Courses.{
    Course,
    CourseOutline
  }

  def seed() do
    Repo.transaction(fn ->
      courses = [
        %{
          title: "Web Development",
          description:
            "Our web development curriculum pathway is designed to teach kids the skills they need to become a successful web developer. The pathway is divided into four courses: kids will learn everything they need to know to create beautiful responsive websites from scratch.",
          # in cents
          amount: 120_000,
          default_currency: "USD",
          age_range: "10-13",
          level: "2",
          unique_name: "web_dev313",
          outlines: [
            %{
              content:
                "Objective: Familiarize students with web development concepts and introduce HTML as the foundation of web pages. Lesson Overview: In this first week, students will dive into the world of web development. They will learn about the role of web developers and designers in creating websites, gaining an understanding of the building blocks that make up web pages. The main focus will be on HTML (HyperText Markup Language), which forms the structure of web content. Students will be guided to set up a basic HTML document, laying the groundwork for their journey into web development. Class Activity: Engage students with a discussion on websites and their significance in the digital age. Introduce the concepts of web development and design, highlighting the collaborative process. Explore examples of various types of websites, from blogs to e-commerce platforms. Examine the essential elements of a web page: HTML, CSS, and JavaScript. Dive into HTML by explaining its role in structuring content and creating organized layouts. Guide students in creating their first HTML page, introducing essential tags: <!DOCTYPE html>, <html>, <head>, and <body>. Assignment: Ask students to select their favorite website and analyze its purpose, layout, and design elements. In the next class, they will present their findings.",
              description:
                "Objective: Familiarize students with web development concepts and introduce HTML as the foundation of web pages. Lesson Overview: In this first week, students will dive into the world of web development. They will learn about the role of web developers and designers in creating websites, gaining an understanding of the building blocks that make up web pages. The main focus will be on HTML (HyperText Markup Language), which forms the structure of web content. Students will be guided to set up a basic HTML document, laying the groundwork for their journey into web development. Class Activity: Engage students with a discussion on websites and their significance in the digital age. Introduce the concepts of web development and design, highlighting the collaborative process. Explore examples of various types of websites, from blogs to e-commerce platforms. Examine the essential elements of a web page: HTML, CSS, and JavaScript. Dive into HTML by explaining its role in structuring content and creating organized layouts. Guide students in creating their first HTML page, introducing essential tags: <!DOCTYPE html>, <html>, <head>, and <body>. Assignment: Ask students to select their favorite website and analyze its purpose, layout, and design elements. In the next class, they will present their findings.",
              title: "Week 1: Introduction to Web Development and HTML Basics",
              order: 1
            },
            %{
              content:
                "Lesson Overview: This week, students will explore the art of text manipulation and formatting using HTML. They will gain insights into the various tags that HTML offers to structure and style text content. Understanding the role of headings, paragraphs, lists, and line breaks in creating visually appealing and organized content will be the core focus. By the end of the week, students will be equipped to craft engaging web content. Class Activity: Begin with a recap of the previous week's introduction to HTML. Delve into text formatting, presenting different HTML tags: headings, paragraphs, and lists. Explore both ordered (numbered) and unordered (bulleted) lists. Discuss the significance of line breaks for maintaining content flow. Showcase examples of each text formatting element to enhance comprehension. Guide students in creating an HTML page with multiple paragraphs and lists, practicing the use of these tags. Assignment: Assign a project where students will create a Personal Profile webpage. They should craft short paragraphs about themselves, their hobbies, and their favorite books/movies, applying various text formatting tags.",
              description:
                "Objective: Teach students how to structure and format text content using HTML tags.",
              title: "Week 2: Elements and tags ",
              order: 2
            },
            %{
              content:
                "Lesson Overview: In this week, students will take their web pages to the next level by learning how to incorporate interactivity through hyperlinks and visual appeal through images. They will discover the power of linking to other web pages and external sites using the <a> tag. Additionally, students will explore the <img> tag, enabling them to enrich their content by embedding images seamlessly. By the end of this week, students will possess the skills to engage users through clickable links and captivating images. Class Activity: Revisit the concepts of HTML basics and text formatting covered in previous weeks. Introduce the <a> tag, emphasizing its role in creating hyperlinks. Showcase how to link to other web pages within the same site and external websites. Demonstrate the <img> tag for embedding images, discussing the importance of alt attributes. Walk students through creating a personal Hobbies webpage with links and images related to their interests. Assignment: Assign a project where students will design a Dream Vacation webpage. They should incorporate clickable links to their dream travel destinations and embed images representing those places.",
              description:
                "Objective: Teach students how to create hyperlinks and embed images in web pages.",
              title: "Week 3: Adding Links and Images",
              order: 3
            },
            %{
              content:
                "Lesson Overview: In this week, students will delve into the art of structuring web pages for enhanced organization and visual appeal. They will learn about the <div> tag, a powerful tool for creating page sections. Additionally, students will venture into the world of basic CSS (Cascading Style Sheets), discovering how to style page elements such as background color and text alignment. By the end of the week, students will have the foundation to craft aesthetically pleasing layouts for their web content. Class Activity: Begin with a recap of the previous weeks, touching on HTML tags and content creation. Introduce the concept of page structure, emphasizing the significance of organized layouts. Explain the <div> tag's role in creating page sections and separating content. Walk students through the basics of CSS, showcasing its application in styling web elements. Lead students in creating a My Family webpage, where they will apply <div> elements for page sections and use CSS to style the layout. Assignment: Assign a project where students will design a personal About Me webpage. They should create a layout with sections for family, hobbies, and future goals, incorporating <div> elements and CSS styling.",
              description:
                "Objective: Introduce the concepts of page structure and basic layout using HTML.",
              title: "Week 4: Page Structure and Layout",
              order: 4
            },
            %{
              content:
                "Lesson Overview: This week, students will explore the interactive side of web development by diving into HTML forms. They will discover the versatility of the <form> tag and various input types, including text fields, radio buttons, checkboxes, and submit buttons. By understanding the role of forms in collecting user input, students will gain the skills to create engaging and interactive web elements. Class Activity: Review the concepts covered in previous weeks, emphasizing page structure and layout. Introduce HTML forms and their significance in user interaction and data collection. Showcase the <form> tag and demonstrate the creation of text input fields. Guide students through adding radio buttons and checkboxes to the form. Discuss the purpose of submit buttons and their role in form submission. Lead students in creating a simple Favorite Foods survey form with checkboxes and radio buttons. Assignment: Assign a project where students will design a Pet Survey webpage using form elements. They should design a form to gather information about people's favorite pets.",
              description:
                "Objective: Teach students about HTML forms and user interaction elements.",
              title: "Week 5: Forms and User Interaction",
              order: 5
            },
            %{
              content:
                "Lesson Overview: In this week, students will explore the dynamic realm of multimedia by learning how to embed videos and audio in web pages. They will discover the <video> and <audio> tags, powerful tools for seamlessly integrating visual and auditory content. By mastering the art of multimedia embedding, students will be able to create engaging and captivating web experiences. Class Activity: Recap the concepts of forms and user interaction covered in the previous week. Introduce the <video> and <audio> tags for embedding videos and audio files. Demonstrate how to embed a video clip and play audio content using these tags. Guide students in creating a webpage featuring their favorite song's audio and a video clip. Assignment: Assign a project where students will create a Book Review webpage. They should embed a video book review and include audio clips of book excerpts.",
              description: "Objective: Introduce embedding multimedia content using HTML.",
              title: "Week 6: Embedding Videos and Audio",
              order: 6
            },
            %{
              content:
                "Lesson Overview: In this week, students will explore the world of data organization and presentation through HTML tables. They will learn about the <table>, <tr>, <td>, and <th> tags that form the foundation of tabular data. By understanding the structure and purpose of these tags, students will be equipped to create organized and visually appealing tables to display information effectively. Class Activity: Begin with a review of the concepts covered in previous weeks, focusing on multimedia embedding. Introduce the concept of tables and their significance in displaying structured data. Explain the <table>, <tr> (table row), <td> (table data), and <th> (table header) tags. Showcase the construction of a basic table with rows and columns. Discuss the importance of headings in table cells and explore styling options for tables. Guide students in creating a simple Sports Scores table displaying game results. Assignment: Assign a project where students will design a Movie Ranking webpage using a table. They should use the table structure to display their favorite movies and their personal ratings.",
              description: "Objective: Introduce students to HTML tables for organizing data.",
              title: "Week 7: Introduction to Tables",
              order: 7
            },
            %{
              content:
                "Lesson Overview: In this week, students will have the opportunity to consolidate their learning by revisiting the concepts and skills covered in previous weeks. They will participate in a comprehensive review that reinforces their understanding of HTML, text formatting, multimedia embedding, forms, tables, and more. Additionally, students will celebrate their accomplishments by showcasing their individual projects to the class. Class Activity: Conduct an in-depth review of the key concepts and skills learned throughout the course. Engage in a class discussion where students can ask questions and seek clarification on any topics. Provide time for students to refine and enhance their previous projects. Organize a project showcase where each student presents their favorite project to the class. Encourage students to share insights, challenges, and lessons learned during the course. Assignment: No new assignment for this week; the focus is on project refinement and presentation.",
              description:
                "Objective: Review concepts covered throughout the course and allow students to showcase their projects.",
              title: "Week 8: Review and Project Showcase",
              order: 8
            }
          ]
        },
        %{
          title: "Game Design",
          description:
            "This is where it all begins! This pathway is designed to help students learn the fundamentals of coding and computational thinking in a fun and engaging way while designing their own games and animations. The pathway is divided into three levels, each of which builds on the skills learned in the previous level.",
          # in cents
          amount: 120_000,
          default_currency: "USD",
          age_range: "7-9",
          level: "1",
          unique_name: "game_dev313",
          outlines: [
            %{
              content:
                "I know what scratch is. I know the the different parts of the Scratch interface. I know how to create a new project in Scratch. I know what sprites are. I know how to add a sprite to a project in Scratch. I know what a script and script block are. I know how to add a backdrop to a project in Scratch. Class Activity: Create a simple animation by adding a sprite to the stage and then writing a script that makes the sprite move around the screen. Assignment: Create a project by using the skills you have learned in class. You can create an animation, a game, or anything else you can imagine. Due Date: Your next class Submission: Share your project with your parent and instructor.",
              description:
                "I know what coding is and how it is used to create interactive animations and games.",
              title: "Week 1: INTRODUCTION TO SCRATCH",
              order: 1
            },
            %{
              content:
                "I can identify different types of event listeners. I can use event listeners to make Scratch projects. I Can adjust the values of event blocks to create unique and customized effects in Scratch. Class Activity: Create a Scratch project that uses event listeners to make a sprite do something different depending on the event that is triggered. Assignment: Use the when key pressed event listener to move the sprite when the user presses the arrow keys. Due Date: Your next class Submission: Share your project with your parent and instructor.",
              description:
                "I know what an event listener is. I understand the concept of event listeners in Scratch.",
              title: "Week 2:EVENT LISTENER",
              order: 2
            },
            %{
              content:
                "I can identify the Pen block and use the Pen tool on a sprite in my project. I can identify the 'change pen color' block and use it to change the color of the Pen. I can identify and use the 'erase all' block in Scratch to erase everything that the Pen has drawn. Class Activity: Create a program that uses the pen tool to draw different shapes, such as squares, circles, and triangles. Assignment: Experiment with different pen sizes and colors to create visually appealing drawings. Due Date: Your next class Submission: Share your project with your parent and instructor.",
              description:
                "I know what the Pen tool is in Scratch. I know the different types of Pen Blocks.",
              title: "Week 3: PEN BLOCK",
              order: 3
            },
            %{
              content:
                "Class Activity: Create a Scratch project that asks a question and then broadcasts the question to all sprites on the stage. The sprites should then respond to the question by broadcasting their answers. Assignment: Create a Scratch project that uses the change x/y by __ block to move a sprite around the stage. The sprite should start at a specific location on the stage, and then it should move a certain number of pixels in the x or y direction each time the script is run. Due Date: Your next class Submission: Share your project with your parent and instructor.",
              description:
                "I know what message broadcasting is in Scratch. I can identify the broadcast block in Scratch I can use the message broadcasting to make sprites communicate with each other. I can use the stop all block to stop all sprites from running their scripts.",
              title: "Week 4: MESSAGE BROADCASTING",
              order: 4
            },
            %{
              content:
                "I can explain when to use each type of loop in a project. I can identify the repeat block and use the repeat block to repeat an action a certain number of times. I can identify the forever block in the Scratch and explain why the forever block is useful for creating certain types of projects, Class Activity: Write a program that uses a loop to count from 1 to 10 and prints each number on the screen. Assignment: Modify the program to count backwards from 10 to 1 and print the numbers in reverse order. Due Date: Your next class Submission: Share your project with your parent and instructor.",
              description:
                "I know what a loop is and when to use a loop in my code. I can identify the different types of loops in Scratch.",
              title: "Week 5: LOOP",
              order: 5
            },
            %{
              content:
                "I can identify the forever block and explain why we use the forever block in Scratch to continuously check a condition. I can use the else statement to create a script that does something different if a certain condition is not met. I can use the if/then/else block to create a script that does different things depending on whether or not a certain condition is met. Class Activity: Create a program in Scratch that asks the user a question and uses an if-then conditional to provide different responses based on their answer. Assignment: Modify the program to include an if-then-else conditional to handle multiple possible answers. Due Date: Your next class Submission: Share your project with your parent and instructor.",
              description:
                "I know what a conditional statement is. I can identify and use conditional statements to control the flow of their code.",
              title: "Week 6: CONDITIONAL STATEMENT",
              order: 6
            },
            %{
              content:
                "I can identity and use the change x by and change y by blocks to move a sprite . a certain number of pixels in the X or Y direction. I can identify and use the goto random position block to move a sprite to a random location on the stage. I can use X/Y coordinates to create simple animations Class Activity: Create a Scratch project that uses the goto random position block to make a sprite move to a random location on the stage Assignment: Create a Scratch project that uses the change x/y by __ block to move a sprite around the stage. The sprite should start at a specific location on the stage, and then it should move a certain number of pixels in the x or y direction each time the script is run. Due Date: Your next class Submission: Share your project with your parent and instructor.",
              description:
                "I know what the coordinate is and how it is used in Scratch. I can identify the X and Y axes on the Scratch stage.",
              title: "Week 7: X AND Y COORDINATE",
              order: 7
            },
            %{
              content:
                "I can create a script that uses a variable to store value. I can create a project that uses a variable to make a decision. Class Activity: Create a program that asks the user for their name and displays a personalized greeting using variables. Assignment: Create a program that asks the user for their age and then displays a message saying You will be __ years old in 10 years. Due Date: Your next class Submission: Share your project with your parent and instructor.",
              description:
                "I know what a variable is. I can identify the variable block, create, and use a variable in my project. I can rename and change a variables value.",
              title: "Week 8: VARIABLE",
              order: 8
            }
          ]
        }
      ]

      Enum.each(courses, fn course ->
        {:ok, new_course} = Course.create(course)

        Enum.each(course.outlines, fn outlines ->
          CourseOutline.create(new_course, outlines)
        end)
      end)

      user = %{
        email: "instructor0313@gmail.com",
        password: "Ahe@d123",
        phone_number: "2348032413264",
        user_type: "user",
        role: :instructor
      }

      profile = %{
        fullname: "John Doe",
        country: "Nigeria"
      }

      {:ok, %User{} = user} = User.create_user(%{user | email: String.downcase(user.email)})
      {:ok, %UserProfile{} = user_profile} = UserProfile.create_user_profile(user, profile)
    end)

    :ok
  end
end
