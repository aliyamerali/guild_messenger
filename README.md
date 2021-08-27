# Guild Messenger API
## Overview
[As requested](prompt.md), this is a very simple Messenger API. With two available endpoints, this API can create new text-based messages between two users, and return messages for a given recipient. 

You may review the feature work for these endpoints in this [pull request](https://github.com/aliyamerali/guild_messenger/pull/1).

Timeframe: 
* ~3 hours coding
* ~1 hour planning + documentation

## Assumptions
* Users (senders and recipients) have unique integer IDs that will be passed to the API endpoints as parameters
* Anonymous messages are not allowed (there must be a sender_id given)
* Empty messages are not allowed (there must be content given) 
* Authorization, Authentication and Registration can be ignored (this is a global API that can be leveraged by anyone, security is not a concern)

## Endpoints
| Endpoint    | Parameters   |  Returns    | 
| ------------- | ------------- | ------------- |
| `GET /api/v1/messages` | `sender_id` (integer, optional field - returns messages from all senders if field is not specified), <br> `recipient_id` (integer, required), <br> `limit` (`"100"` or `"30d"`, required) | _**If Successful:**_ `200` response and a list of all messages meeting the specified parameters, returned in the format outlined by [JSON:API](https://jsonapi.org/), <br>_**If Unsuccessful:**_ `400 Bad Request` (missing parameters) |
| `POST /api/v1/messages` | `sender_id` (integer, required), <br> `recipient_id` (integer, required), <br> `content` (string, required) | _**If Successful:**_ `201 Created`, <br> _**If Unsuccessful:**_ `400 Bad Request` (missing parameters) |

### Sample API Call - Create Message
**Request**   
Verb + Path: `POST http://localhost:3000/api/v1/messages`   
Body: 
```
{
"sender_id": 1234, 
"recipient_id": 5678, 
"content": "Don't worry, about a thing"
}
```
**Response**   
Status: `201 Created`   
Body:
```
{
    "response": "Created"
}
```

### Sample API Call - Get Messages
**Request**   
Verb + Path: `GET http://localhost:3000/api/v1/messages`   
Body: 
```
{
"sender_id": 1234, 
"recipient_id": 5678, 
"limit": "100"
}
```
**Response**   
Status: `200 OK`   
Body:
```
{
    "data": [
        {
            "id": "5",
            "type": "message",
            "attributes": {
                "sender_id": 1234,
                "recipient_id": 5678,
                "content": "Don't worry, about a thing",
                "created_at": "2021-08-27T13:55:26.670Z"
            }
        },
        {
            "id": "4",
            "type": "message",
            "attributes": {
                "sender_id": 1234,
                "recipient_id": 5678,
                "content": "Don't worry, about a thing",
                "created_at": "2021-08-27T00:17:17.236Z"
            }
        },
        {
            "id": "1",
            "type": "message",
            "attributes": {
                "sender_id": 1234,
                "recipient_id": 5678,
                "content": "This is a message for you-ooh-ooh",
                "created_at": "2021-08-26T22:16:28.820Z"
            }
        }
    ]
}
```


## Schema
![Screen Shot 2021-08-26 at 6 46 57 PM](https://user-images.githubusercontent.com/5446926/131053994-cd290857-82e1-4557-b472-537a35c05181.png)

## Technologies
* Ruby 2.7.2
* Rails 6.0.4.1
* PostgreSQL 13.4
* Gems: 
  *  [RSpec](https://github.com/rspec/rspec-rails)
  *  [Shoulda-Matchers](https://github.com/thoughtbot/shoulda-matchers)
  *  [SimpleCov](https://github.com/simplecov-ruby/simplecov)
  *  [jsonapi-serializer](https://github.com/jsonapi-serializer/jsonapi-serializer)

## Local Setup
To setup these endpoints locally: 
1. clone this repo to your local machine
2. run `bundle install`
3. run `rails db:{create,migrate}` to setup the database
4. run `rails s` and navigate to http://localhost:3000 with the desired endpoint for `get` requests, and/or use a tool like [Postman](https://www.postman.com) for `post` requests. 

## Next Steps
Given additional time, here's what I'd like to work on:
* Refactor! Cleanup methods for increased readability, DRY-ness and SRP 
* Add an ErrorSerializer to return 400 responses in the [JSON:API](https://jsonapi.org/) convention 
* Refactor to provide more detailed error responses (which field is mising, e.g.)
* Include additional edge case handling:
  * Set a character limit on message content to ensure it fits within the database
* Leverage a gem like [FactoryBot](https://github.com/thoughtbot/factory_bot_rails) to cleanup test setup
