#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE games, teams;") 
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != year ]]
then
  # get winner team
  WINNER_TEAM=$($PSQL "SELECT * FROM teams WHERE name='$WINNER'")

  # if not found
  if [[ -z $WINNER_TEAM ]]
  then
    # insert winner
    INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER == "INSERT 0 1" ]]
    then  
      echo Inserted into teams, $WINNER
    else
      echo Fail to insert winner
    fi
  fi
 # get opponent team
  OPPONENT_TEAM=$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT'")

  # if not found
  if [[ -z $OPPONENT_TEAM ]]
  then
    # insert opponent
    INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
    then  
      echo Inserted into opponents, $OPPONENT
    else
      echo Fail to insert opponent
    fi
  fi
  # games table
  # get winner_id and opponent_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # insert data in games table
    INSERT_GAMES_RESULTS=$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS, '$ROUND')")
    if [[ $INSERT_GAMES_RESULTS == "INSERT 0 1" ]]
    then  
      echo Inserted into games
    else
      echo Fail to insert data
    fi
fi  
done
