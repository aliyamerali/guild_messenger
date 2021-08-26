require 'rails_helper'

RSpec.describe 'Create Message Endpoint' do
  describe 'happy path' do
    it 'creates a message record when all required information is present' do
      sender_id = 1234
      recipient_id = 5678
      content = "This is a message for you-ooh-ooh"
      body = {"sender_id": sender_id, "recipient_id": recipient_id, "content": content}

      post '/api/v1/messages', params: body, as: :json

      expect(response).to be_successful
      expect(Message.last.content).to eq(content)
    end

    it 'returns a 201 response when message is successfully created' do
      sender_id = 1234
      recipient_id = 5678
      content = "Baby, don't worry"
      body = {"sender_id": sender_id, "recipient_id": recipient_id, "content": content}

      post '/api/v1/messages', params: body, as: :json

      expect(response).to be_successful
      expect(response.status).to eq(201)
    end
  end

  describe 'sad path' do
    it 'returns a 400 response when all required fields are not present'
  end
end
