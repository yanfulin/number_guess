#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=guess -t --no-align -c"

USER_INTRO() {
echo "Enter your username:"
#read USER
read USER
USER_ID=$($PSQL "select user_id from users where name='$USER'")
if [[ -z $USER_ID ]]
then
  RES=$($PSQL "INSERT INTO users(name) VALUES('$USER');")
  # Get the assigned user id
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USER'")
  echo -e "\nWelcome, $USER! It looks like this is your first time here."
  
else
  game_played=$($PSQL "select count(game_id) from games group by user_id having user_id='$USER_ID'")
  game_min=$($PSQL "select min(guesses) from games group by user_id having user_id='$USER_ID'")
  if [[ -z $game_played ]]
  then
    COUNT=0
    MIN=0
  else
    COUNT=$game_played
    MIN=$game_min
  fi
  echo -e "\nWelcome back, $USER! You have played $COUNT games, and your best game took $MIN guesses."
fi
}

GAME() {
# generate the random number
NUMBER=$(($RANDOM%1000+1))
echo $NUMBER
GUESS=-1
ITTER=0
# Read the user's input
echo -e "Guess the secret number between 1 and 1000:"

while [[ $GUESS -ne $NUMBER ]]
do
  read GUESS
  ITTER=$(($ITTER+1))
  # Check whether it's integer
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
    #If it's integer
    # Tell the user input is higher or lower, guess agin
    elif [[ $GUESS -gt $NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    elif [[ $GUESS -lt $NUMBER ]]
    then
      echo "It's higher than that, guess again:"
    fi
done
}

END_GAME() {
  RES=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $ITTER);")
  echo "You guessed it in $ITTER tries. The secret number was $NUMBER. Nice job!"
}


USER_INTRO
GAME
END_GAME
#Good
