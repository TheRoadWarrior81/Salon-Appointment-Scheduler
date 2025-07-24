#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ SALON APPOINTMENT SCHEDULER ~~~~~\n"

# Main menu
MAIN_MENU() {
  echo -e "\nWelcome to the Salon! How can we help you today?\n"
  
  # Display available services
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id;")
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

  echo -e "\nPlease enter the service number you'd like:"
  read SERVICE_ID_SELECTED

  # Validate service ID
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
  if [[ -z $SERVICE_NAME ]]; then
    echo -e "\n❌ Invalid service number. Please try again."
    MAIN_MENU
    return
  fi

  # Get customer phone number
  echo -e "\nEnter your phone number:"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

  # If customer doesn't exist, ask for name and insert
  if [[ -z $CUSTOMER_NAME ]]; then
    echo -e "\nIt seems you're a new customer. What's your name?"
    read CUSTOMER_NAME
    INSERT_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")

  # Get appointment time
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # Insert appointment
  APPOINTMENT_INSERT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")

  echo -e "\n✅ I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
