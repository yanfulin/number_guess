--psql --username=freecodecamp --dbname=postgres

-- create database guess
-- create tables
-- Drop database guess;
-- Create database guess;
Drop table users;
Drop table games;
Create table users(
  user_id serial primary key,
  name varchar(25) not null
);
create table games(
  game_id serial primary key,
  user_id int references users(user_id),
  guesses int not null
);
