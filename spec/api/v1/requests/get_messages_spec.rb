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
                      created_at: DateTime.new(2021,5,01)
                      )
      end

      # 25 messages from sender A within 60 days
      25.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_a_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2021,7,01)
                      )
      end

      # 25 messages from sender A within 30 days
      25.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_a_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2021,8,15)
                      )
      end

      # 25 messages from sender B within 30 days
      50.times do |index|
        Message.create!(
                      recipient_id: @recipient_id,
                      sender_id: @sender_b_id,
                      content: "Message #{index}",
                      created_at: DateTime.new(2021,8,15)
                      )
      end

      # # stub out Time.now to return 8/20/21
      # allow(Time).to receive(:now) do
      #   DateTime.new(2021,8,20)
      # end
    end

    it 'returns recipient\'s last 100 messages from a given sender' do
      limit = "100"
      get "/api/v1/messages?recipient_id=#{@recipient_id}&sender_id=#{@sender_a_id}&limit=#{limit}"

      output = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
      expect(output[:data].length).to eq(100)
      expect(output[:data].first[:type]).to eq("message")
      expect(output[:data].first[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].first[:attributes][:created_at]).to eq("2021-08-15T00:00:00.000Z")
      expect(output[:data].last[:attributes][:sender_id]).to eq(@sender_a_id)
      expect(output[:data].last[:attributes][:created_at]).to eq("2021-05-01T00:00:00.000Z")
    end

    it 'returns recipient\'s last 30 days of messages from a given sender'
    it 'returns recipient\'s last 100 messages from all senders if non specified'
    it 'returns recipient\'s last 30 days of messages from all senders if non specified'
  end

end
