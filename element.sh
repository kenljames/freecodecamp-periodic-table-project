#!/bin/bash
# Project Script for FreeCodeCamp RDB Certificate

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"


if [[ -z "$1" ]]
  then
    echo Please provide an element as an argument.
  else
    # if arguments an integer
    if [[ $1 =~ ^[0-9]+$ ]]
      then
      # query atomic number
      RETURN_ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
      # else if strings short
        elif [[ $1 =~ ^([a-z]||[A-Z])([a-z]||[A-Z])$ ]]
          then
            RETURN_ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1'")
          else
            # else argument must be a name
            RETURN_ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1'")
    fi
    if [[ ! -z "$RETURN_ELEMENT" ]]
    then
      #ELEMENT_INFO_ARRAY=(${RETURN_ELEMENT//|/ })
      echo $RETURN_ELEMENT | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT #<<<${ELEMENT_INFO_ARRAY[*]}
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
    else
      echo "I could not find that element in the database."
    fi
fi
exit
