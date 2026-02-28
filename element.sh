#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

INPUT="$1"

# Determine input type
if [[ $INPUT =~ ^[0-9]+$ ]]; then
  CONDITION="e.atomic_number=$INPUT"
elif [[ $INPUT =~ ^[A-Za-z]{1,2}$ ]]; then
  CONDITION="e.symbol='$INPUT'"
else
  CONDITION="e.name='$INPUT'"
fi

# Query
RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
FROM elements e 
JOIN properties p ON e.atomic_number = p.atomic_number 
JOIN types t ON p.type_id = t.type_id 
WHERE $CONDITION")

# Handle no result
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Parse and print
IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."