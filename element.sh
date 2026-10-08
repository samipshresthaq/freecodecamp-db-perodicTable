#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

EXTRACT_ELEMENT(){
  if [[ $1 ]]
  then
    if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
    else
      ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' OR name='$1'")
    fi

    if [[ -z $ELEMENT ]]
    then 
      echo 'I could not find that element in the database.'
    else
      echo $ELEMENT | while IFS="|" read -r AN SYMBOL NAME
      do
        PROPS=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties JOIN types USING(type_id) WHERE atomic_number='$AN'")

        echo $PROPS | while IFS="|" read -r AM MP BP TYPE 
        do
          echo "The element with atomic number $AN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
        done
      done
    fi
  else 
    echo -e "Please provide an element as an argument."
  fi
}

EXTRACT_ELEMENT $1