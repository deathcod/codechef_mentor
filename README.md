# Codechef mentor
Creating Application that helps competitive programmers to learn more by taking help from mentors. This is the back-end implementation on Ruby on Rails, our front-end is build on andriod. Please build your application, customize and start using [Sandip-Jana/codechef-mentor](https://github.com/Sandip-Jana/codechef-mentor).

## Getting Started

For setting up the server, follow the following steps  
* setup MySql in your local environment `5.7.23`
* setup Redis in your local environment
* install `ruby-2.3.0` and Rails `5.2.1`
* build the app by install gem `bundle install`
* visit `config/database.yml` and place the database name for different environment [testing, development, production] also update the password of your database.
* build assets `rake assets:precompile RAILS_ENV=production`
* create database `bundle exec rails db:create`
* migrate database to create tables `bundle exec rails db:migrate`
* to start server in development mode `bundle exec rails s`
* to start server in production mode `bundle exec rails s production`

## Authentication Architecture
![authentication image](https://github.com/deathcod/codechef_mentor/blob/master/config/authentication.png)

## Backend Architecture
![bcakend image](https://github.com/deathcod/codechef_mentor/blob/master/config/backend_architecture.png)

## API end-points
```
GET  /mentors                        # get list of mentors related to current user
GET  /students                       # get list of students related to current user
GET  /users                          # get list of mentors and students linked to a user  
GET  /leaderboard                    # get the list of users and score 
GET  /chats                          # [deprecated] get all chats
GET  /chats/:id                      # get all chats for a particular chat room
GET  /users/auth/codechef            # REDIRECT URL for codechef
GET  /users/download_profile_pic     # get the profile pic of the current user
GET  /users/logout                   # clear cookie and auth code
POST /users/authenticate             # set cookie and auth code
POST /user                           # create relationship between current user and mentor
POST /users/upload_profile_pic       # save user's profile pic
PUT  /user/:current_user             # update relationship status
```

## TODO
The following features we will work in future
* create push notifications
* allow users to create their own chat channels
* allow users to **record chat** and use it as notes
* create tag based search for questions and mentors

## Contribution
We would love to see contributions to our codebase. To start contributing follow the steps.
* fork the git repository
* clone the forked reposition
* make changes and add feature
* raise a pull request to merge with master

## Contact 
Reach out to me at chinmay.rakshit@gmail.com for any queries. Also report issues, we will look into it and fix