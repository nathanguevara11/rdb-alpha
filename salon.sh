#!/bin/bash 

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "Welcome" 

MAIN_MENU(){
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

echo "$SERVICES" | while IFS="|" read SERVICE_ID NAME
do
  echo -e "$SERVICE_ID) $NAME"
done

read SERVICE_ID_SELECTED

SERVICE_LOOKUP=$($PSQL "SELECT service_id, name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ -z $SERVICE_LOOKUP ]]
  then echo -e "This service is not provided. Try again"
  MAIN_MENU
fi
}

MAIN_MENU

echo -e "\nEnter your phone number"

read CUSTOMER_PHONE

CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]
  then 
  echo -e "Phone not found, enter name"
  read CUSTOMER_NAME  
  $PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')"
fi

echo -e "Select a time"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
$PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')"

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."