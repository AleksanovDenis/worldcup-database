#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
"$($PSQL "TRUNCATE teams, games;")"
cat ./games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    #get winner_id and opponent_id from teams table
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"
    #if not found, insert team into teams table
    if [[ -z $WINNER_ID ]]
    then
      echo "$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")"
      echo -e "\nInsert into teams table: $WINNER"
      WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
    fi
    
    if [[ -z $OPPONENT_ID ]]
    then
      echo "$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")"
      echo -e "\nInsert into teams table: $OPPONENT"
      OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"
    fi
    #Insert data into games table
    echo "$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")"
    echo -e "\n Insert into games table: year: $YEAR, round: $ROUND, winner_id: $WINNER_ID, opponent_id: $OPPONENT_ID, winner_goals: $WINNER_GOALS, opponent_goals: $OPPONENT_GOALS"
  fi
done
