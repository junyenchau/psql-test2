#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")
cat games.csv | while IFS="," read YEAR RD WINNER OPP WGOAL OGOAL
do 
  if [[ $YEAR != year ]]
  then
    WINNERID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")

    if [[ -z $WINNERID ]]
    then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
      WINNERID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    if [[ -z $OPPID ]]
    then
      INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPP');")
      if [[ $INSERT_OPP_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPP
      fi
      OPPID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    fi 

    INSERTGAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$RD', $WINNERID, $OPPID, $WGOAL, $OGOAL);")

  fi
done