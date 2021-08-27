# Guild Messenger API
## Overview
[As requested](prompt.md), this is a _very simple_ Messenger API. With two available endpoints, this API can create new text-based messages between two users, and return messages for a given recipient. 

## Assumptions
* Users (senders and recipients) have unique integer IDs that will be passed to the API endpoints as parameters
* Anonymous messages are not allowed (there must be a sender_id given)
* Empty messages are not allowed (there must be content given) 
* Authorization, Authentication and Registration can be ignored (this is a global API that can be leveraged by anyone, security is not a concern)

## Endpoints
| Endpoint    | Parameters   |  Returns    | 
| ------------- | ------------- | ------------- |
| `GET /api/v1/messages` | `sender_id` (integer, optional field - returns messages from all senders if field is not specified), `recipient_id` (integer, required), `limit` (`"100"` or `"30d"`, required) | `200` response and a list of all messages meeting the specified parameters, returned in the format outlined by [JSON:API](https://jsonapi.org/) if successful,`400 Bad Request` if unsuccessful (missing parameters) |
| `POST /api/v1/messages` | `sender_id` (integer, required), `recipient_id` (integer, required), `content` (string, required) | `201 Created` if successful, `400 Bad Request` if unsuccessful (missing parameters) |

## Schema
![Screen Shot 2021-08-26 at 6 46 57 PM](https://user-images.githubusercontent.com/5446926/131053994-cd290857-82e1-4557-b472-537a35c05181.png)

## Technologies
* Ruby 2.7.2
* Rails 6.0.4.1
* PostgreSQL 13.4
* RSpec

## Local Setup
To setup these endpoints locally: 
1. clone this repo to your local machine
2. run `bundle install`
3. run `rails db:{create,migrate}` to setup the database
4. run `rails s` and navigate to http://localhost:3000 with the desired endpoint for `get` requests, and/or use a tool like [Postman](https://www.postman.com) for `post` requests. 

## Next Steps
Given additional time, here's what I'd like to work on:
* Adding an ErrorSerializer to return 400 responses in the [JSON:API](https://jsonapi.org/) convention 
* Include additional edge case handling:
  * Set a character limit on message content to ensure it fits within the database
* Refactor test setup to leverage a gem like [FactoryBot](https://github.com/thoughtbot/factory_bot_rails)
