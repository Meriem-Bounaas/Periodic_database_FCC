PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

ARGUMENT=$1

if [[ -z $ARGUMENT ]]
then
  echo "Please provide an element as an argument."
else 
  if [[ $ARGUMENT =~ ^[0-9]+$ ]]
  then
    DATA=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type  from properties join elements using(atomic_number) join types using(type_id) where elements.atomic_number=$ARGUMENT ")
  else
    DATA=$($PSQL "select atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name, type from properties join elements using(atomic_number) join types using(type_id) where elements.name LIKE '$ARGUMENT%' order by atomic_number limit 1 ")
  fi
  if [[ -z $DATA ]]
  then
    echo "I could not find that element in the database."
  else
    echo $DATA | while IFS=\| read ATOMIC_NBR ATOMIC_MASS MELTING BOILING SYMBOL NAME TYPE   
    do
      echo "The element with atomic number $ATOMIC_NBR is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
           
    done
  fi
fi

