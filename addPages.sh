#!/bin/bash
# set -x  # tracing on
set +x  # tracing off

#
# Env
#
if [ ! -f ./.env ]; then
 echo "The .env file was not found!"
 exit 1
fi
source .env

if [ -z "$NOTION_KEY" ]; then
  echo "NOTION_KEY not set!"
  echo 1
fi
if [ -z "$NOTION_DB_ID" ]; then
  echo "NOTION_DB_ID not set!"
  echo 1
fi
# if [ -z "$NOTION_PAGE_ID" ]; then
#   echo "NOTION_PAGE_ID not set!"
#   echo 1
# fi

#
# Start date
#
read -p "Enter start date (YYYY-MM-DD, ex: 2023-08-01)? " START_DATE

# Validate date
date -f "%Y-%m-%d" -j "$START_DATE" > /dev/null  2>&1
is_valid=$?

if [ "$is_valid" != "0" ]; then
  echo "Date is invalid!"
  exit 1
fi

#
# Count
#
read -p "How many pages? (a number between 1 and 31)? " COUNT

# Validate count
if [ "$COUNT" -lt "1"  ] || [ "$COUNT" -gt "31" ]; then
  echo "Count out of range!"
  exit 1
fi
echo $COUNT


##################################################################
# Main loop
##################################################################

NEXT_DATE="$START_DATE"
for i in $(seq "$COUNT"); do

  printf "\nccAdd %s\n\n" $NEXT_DATE

  JSON_STRING=$( 
    jq -n --arg date "$NEXT_DATE" --arg db "$NOTION_DB_ID" \
      '{ 
        parent: { database_id: $db },
        properties: {
         Name: { title: [{ text: {content: "TODO"} }]},
         Date: { date: { start: $date}}
      }
    }' 
  )
  #
  # DB
  #
  curl 'https://api.notion.com/v1/pages' \
    -H 'Authorization: Bearer '"$NOTION_KEY"'' \
    -H "Content-Type: application/json" \
    -H "Notion-Version: 2022-06-28" \
    --data "$(echo $JSON_STRING)"

  NEXT_DATE=$(date -j -v +1d -f "%Y-%m-%d" "$NEXT_DATE" +%Y-%m-%d)

done
