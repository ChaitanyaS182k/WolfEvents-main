WolfEvents: The Event Management System
======================
Event Management System is created using Ruby on Rails. This is a program 2 assignment for CSC 517. Event Management System enables attendees to explore Events and purchase Tickets. Attendees can also provide Reviews for the events they have attended. Additionally, the Admin has the capability to create events, and access information on all Attendees, Tickets, and Reviews.

**Please update on this email if application is not running on VCL: crsrusti@ncsu.edu ndoshi2@ncsu.edu sudama@ncsu.edu**

## Link to the deployed application
http://152.7.177.44:8080/

## Admin credentials
* email : admin@gmail.com
* password : Admin@123

## Setting up

* Installation of Ruby version 3.0.0
```
1. cd $HOME
2. sudo apt-get remove ruby
3. sudo apt update 
4. sudo apt install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev
5. git clone https://github.com/rbenv/rbenv.git ~/.rbenv
6. echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
7. echo 'eval "$(rbenv init -)"' >> ~/.bashrc
8. exec $SHELL
9. git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
10. echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
11. exec $SHELL
12. rbenv install 3.0.0
13. rbenv global 3.0.0
```

* Clone this repository
```
git clone https://github.ncsu.edu/Program-2-Ruby-on-Rails/WolfEvents.git
```
* Go to the directory
```
cd WolfEvents
```
* Install required gems
```
bundle install
```
* Run database migration on your system
```
rails db:migrate
```
* Run seed for the setting up required data
```
rails db:seed
```
* Finally, run the rails server
```
rails server
```


## Admin Functionalities:

1. Log In:
   Admins can log in using their email and a password.

2. Edit Profile:
   Admins can edit their own profiles, but cannot update ID, email, and password.

3. View All the Events:
   Admins can view all the events that are available on the system.

4. List Events by Category/Date/Price/Event Name:
   Admins can list events by a specific category, date, price (~ price range to be precise), and event name.

5. View All Users:
   Admins can view all the attendees signed up on the event management system.

6. List Reviews by User:
   Admins can list reviews written by a specific user (by name).

7. List Reviews for a Specific Event:
   Admins can list reviews written for a specific event (with Event name)

8. Manage Attendees:
   Admins can create, view, edit, and delete attendees.

9. Manage Events:
   Admins can create, view, edit, and delete events.

10. Manage Tickets:
    Admins can create, view, edit, and delete tickets.

11. Manage Reviews:
    Admins can create, view, edit, and delete reviews.

12. Manage Rooms:
    Admins can create, view, edit, and delete rooms.
    
    - Admins can delete rooms when the rooms don't have an event scheduled within.

    - Admin should be able to search only available rooms in a particular time slot
      (If a room is already booked, that should not be visible for the admin as part of his/her event creation during the time slot when the room is booked)

13. Admin should also be able to book events like an attendee and attend them.


## Attendee Functionalities:

1. Sign Up for a New Account:
   Attendees can create a new account on the system.

2. Log In:
   Attendees can log in using their email and a password.

3. Edit Profile:
   Attendees can edit their own profiles, except for updating their ID.

4. Delete Account:
   Attendees have the option to delete their own accounts.

    - All Dependents should be deleted. Ex: Tickets booked by attendee or reviews written for the attended events by attendee should be deleted.

5. View Available Events:
   Attendees can view upcoming events with available seats.

6. Filter Events by Category/Date/Price:
   Attendees can filter events by Category/Date/Price (Price range):

7. List Events by Event Name:
   Attendees can search Events by Event Name.

8. Book a Event Ticket:
   Attendees can book a Event Ticket for themselves or for another person.

9. Check Booking History:
   Attendees can check their own booking history.

10. Write Event Reviews:
    Attendees can write reviews for events they have attended, but only for the events with categories of Concerts, Sports, and Arts & Theatre categories. Attendees can review only after the event ends, and by logic, reviews should be visible only after the event ends.

11. Edit Own Reviews:
    Attendees can edit the reviews they wrote but cannot edit reviews by other users.

12. List Reviews by User:
    Attendees can list reviews written by a specific user (by Email of the User).

13. List Reviews for a Specific Event:
    Attendees can list reviews written for a specific event (by Event Name).

14. Cancel a Ticket:
    Attendees can cancel their booked tickets.

There will be 6 main components in the system:

1.  Admin

2.  Attendee

3.  Room

4.  Event

5.  Event Ticket

6.  Review



Admin / Attendee
-----

The system should have only one preconfigured admin with at least the following attributes:

-   ID
-   Email

-   Password

-   Name

-   Phone number

-   Address

-   Credit Card number (Fake one!)

Event
-----

The system should be initialized with scheduled Events, which only the Admin can create. The Attendee would be able to select one of these Events according to their preferences. This class should have, at a minimum, the following attributes.

- ID
- Event name
- Event room ID
- Event category (Concerts, Sports, Arts & Theatre, Miscellaneous/Family – Private)
- Event date
- Event start time
- Event end time
- Ticket price
- Number of seats left


Event Ticket
------

The system should have a Ticket made when an Attendee books an Event. The functionalities related to Tickets are mentioned under Attendee and Admin. This class will have at least the following attributes:


- ID
- Attendee ID
- Event ID
- Room ID
- Confirmation number
- Quantity



Room
---------

The system should allow the admin only to book events in a particular Room for a particular time slot. The functionalities related to Room are mentioned under Admin. This class will have at least the following attributes:

- ID
- Room location/address
- Room capacity


Review
------

The system should have Attendees who can give Reviews on the events they have attended, the booking process, the website, etc. It should have at least the following attributes:


- Attendee ID
- Event ID
- Rating (1 – 5)
- Feedback


## Bonus (Extra Credit):
1. This project correctly implemented a search function for the admin to use. The input is the event name; the search result is a list of attendees who booked this event.
* To access this:  
  -> Log in as admin
  -> Go to "Get All Attendees by Event Name"
  -> Enter Event Name to get list of attendees who booked that event

2. This project implemented a function to allow an attendee to buy a ticket for another attendee (the ticket can be viewed by both the user who pays for the ticket and the user who receives the ticket).

* To access this:  
  -> Log in as Attendee  
  -> Go to "View Available Events"  
  -> Select the event and click on Purchase Ticket Option.
  -> In the ticket booking section select the attendee for whom you want the book ticket for.

## Test Cases

Add the following in the Gemfile

```
group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem 'rspec-rails', '~> 5.0.0'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
end
```
Run the ```bundle install``` command

Run the following command to setup Rspec
```
rails g rspec:install
```
We have added testing for Room. To run the room controller test run:
```
rspec spec/controllers/rooms_controller_spec.rb
```
For the room model test run:
```
rspec spec/models/room_spec.rb
```






