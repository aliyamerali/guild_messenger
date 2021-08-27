require 'rails_helper'

RSpec.describe 'Get User\'s Messages Endpoint' do
  describe 'happy path' do
    before :each do
      @recipient_id = 1234
      @sender_a_id = 5678
      @sender_b_id = 9999

      # 75 messages from sender A within 120 days
      75.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_a_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2020,5,01)
                      )
      end

      # 25 messages from sender A within 60 days
      25.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_a_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2020,7,01)
                      )
      end

      # 25 messages from sender A within 30 days
      25.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_a_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2020,8,15)
                      )
      end

      # 50 messages from sender B within 30 days
      50.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_b_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2020,7,21)
                      )
      end

      # stub out Time.now to return 8/20/21
      allow(DateTime).to receive(:now) do
        DateTime.new(2020,8,20)
      end
    end

    it 'returns recipient\'s last 100 messages from a given sender' do
      limit = "100"
      get "/api/v1/messages?recipient_id=#{@recipient_id}&sender_id=#{@sender_a_id}&limit=#{limit}"

      output = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(output[:data].length).to eq(100)
      expect(output[:data].first[:type]).to eq("message")
      expect(output[:data].first[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].first[:attributes][:created_at]).to eq("2020-08-15T00:00:00.000Z")
      expect(output[:data].last[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].last[:attributes][:created_at]).to eq("2020-05-01T00:00:00.000Z")
    end

    it 'returns recipient\'s last 30 days of messages from a given sender' do
      limit = "30d"
      get "/api/v1/messages?recipient_id=#{@recipient_id}&sender_id=#{@sender_a_id}&limit=#{limit}"

      output = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(output[:data].length).to eq(25)
      expect(output[:data].first[:type]).to eq("message")
      expect(output[:data].first[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].first[:attributes][:created_at]).to eq("2020-08-15T00:00:00.000Z")
      expect(output[:data].last[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].last[:attributes][:created_at]).to eq("2020-08-15T00:00:00.000Z")
    end

    it 'returns recipient\'s last 100 messages from all senders if non specified' do
      limit = "100"
      get "/api/v1/messages?recipient_id=#{@recipient_id}&limit=#{limit}"

      output = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(output[:data].length).to eq(100)
      expect(output[:data].first[:type]).to eq("message")
      expect(output[:data].first[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].first[:attributes][:created_at]).to eq("2020-08-15T00:00:00.000Z")
      expect(output[:data][50][:attributes][:sender_id]).to eq(@sender_b_id)
      expect(output[:data][50][:attributes][:created_at]).to eq("2020-07-21T00:00:00.000Z")
      expect(output[:data].last[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].last[:attributes][:created_at]).to eq("2020-07-01T00:00:00.000Z")
    end

    it 'returns recipient\'s last 30 days of messages from all senders if non specified' do
      limit = "30d"
      get "/api/v1/messages?recipient_id=#{@recipient_id}&limit=#{limit}"

      output = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(output[:data].length).to eq(75)
      expect(output[:data].first[:type]).to eq("message")
      expect(output[:data].first[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].first[:attributes][:created_at]).to eq("2020-08-15T00:00:00.000Z")
      expect(output[:data].last[:attributes][:sender_id]).to eq(@sender_b_id)
      expect(output[:data].last[:attributes][:created_at]).to eq("2020-07-21T00:00:00.000Z")
    end
  end

  describe 'sad path' do
    it 'returns error if recipient_id parameter is missing' do
      limit = "100"
      get "/api/v1/messages?limit=#{limit}"

      expect(response.status).to eq(400)
    end

    it 'returns error if recipient_id parameter is invalid' do
      limit = "100"
      invalid_recipient_id = "string_val"
      get "/api/v1/messages?recipient_id=#{invalid_recipient_id}&limit=#{limit}"

      expect(response.status).to eq(400)
    end

    it 'returns error if limit parameter is missing' do
      get "/api/v1/messages?recipient_id=#{@recipient_id}"

      expect(response.status).to eq(400)
    end
    it 'returns error if limit parameter is invalid' do
      invalid_limit = "string_val"
      get "/api/v1/messages?recipient_id=#{@recipient_id}&limit=#{invalid_limit}"

      expect(response.status).to eq(400)
    end
  end
end
