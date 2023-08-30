# notion-api

Scripts to interact with notion via api

## Prepare your Mac

Ref [install-homebrew-on-mac](https://setapp.com/how-to/install-homebrew-on-mac)

Open a terminal (command+space then type terminal)

```sh
# Install xcode
xcode-select --install

# Install homebrew
/bin/bash bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

## Integration

* [create-a-notion-integration](https://developers.notion.com/docs/create-a-notion-integration)
  
## How to get a Page ID in Notion

* open the page you want the ID of, click on the Share button, and click on the Copy button:

```sh
https://www.notion.so/tonygilkerson/Integration1-f8fa398a627148c9944138f06e728ed5?pvs=4
```

This is the pageid: `Integration1-f8fa398a627148c9944138f06e728ed5`

## Where can I find my database's ID?

Here's a quick procedure to find the database ID for a specific database in Notion:

* Open the database as a full page in Notion.
* Use the Share menu to Copy link.
* Now paste the link in your text editor so you can take a closer look.
* The URL uses the following format:

```sh
https://www.notion.so/{workspace_name}/{database_id}?v={view_id}
```

* Find the part that corresponds to {database_id} in the URL you pasted.
* It is a 36 character long string. This value is your database ID.

> Note that when you receive the database ID from the API, e.g. the search endpoint, it will contain hyphens in the UUIDv4 format. You may use either the hyphenated or un-hyphenated ID when calling the API.

## Curls

### Query db

```sh
curl -X POST "https://api.notion.com/v1/databases/$NOTION_DB_ID/query" \
  -H 'Authorization: Bearer '"$NOTION_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
--data '{}'
```

## Add a page

Ref [post-page](https://developers.notion.com/reference/post-page)

```sh
curl 'https://api.notion.com/v1/pages' \
  -H 'Authorization: Bearer '"$NOTION_KEY"'' \
  -H "Content-Type: application/json" \
  -H "Notion-Version: 2022-06-28" \
  --data '{
            "parent": {
              "database_id": "ed7d6b0b53b5417e83320f9cc11a701e"
            },
            "properties": {
              "Name": {"title": [{ "text": {"content": "DDDDD"} }]},
              "Date": {"date": {"start": "2023-08-01"}}
            }
          }'
```
